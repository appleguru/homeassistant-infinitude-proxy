#!/usr/bin/env bash
# Print a Markdown list of the upstream commits between two image digests,
# using the git revision recorded in each image's SLSA provenance.
set -euo pipefail

image="${UPSTREAM_IMAGE:?}"
repo="${UPSTREAM_REPO:?}"
old_digest="$1"
new_digest="$2"

token="$(curl -fsSL "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${image}:pull" | jq -r .token)"

registry() {
  curl -fsSL \
    -H "Authorization: Bearer ${token}" \
    -H "Accept: application/vnd.oci.image.index.v1+json" \
    -H "Accept: application/vnd.oci.image.manifest.v1+json" \
    "https://registry-1.docker.io/v2/${image}/$1"
}

revision() {
  local attestation layer
  attestation="$(registry "manifests/$1" | jq -r '[.manifests[]? | select(.annotations["vnd.docker.reference.type"] == "attestation-manifest")][0].digest // empty')"
  [ -n "${attestation}" ] || return 0
  layer="$(registry "manifests/${attestation}" | jq -r '[.layers[] | select((.annotations["in-toto.io/predicate-type"] // "") | startswith("https://slsa.dev/provenance/"))][0].digest // empty')"
  [ -n "${layer}" ] || return 0
  registry "blobs/${layer}" | jq -r '.predicate.buildDefinition.externalParameters.configSource.digest.sha1 // .predicate.invocation.configSource.digest.sha1 // empty'
}

old_rev="$(revision "${old_digest}" || true)"
new_rev="$(revision "${new_digest}" || true)"

if [ -z "${old_rev}" ] || [ -z "${new_rev}" ]; then
  echo "- Upstream did not record source revisions for these images; see https://github.com/${repo}/commits."
  exit 0
fi

compare="https://github.com/${repo}/compare/${old_rev:0:7}...${new_rev:0:7}"
if ! commits="$(gh api "repos/${repo}/compare/${old_rev}...${new_rev}" | jq -r --arg repo "${repo}" '
    select(.status == "ahead")
    | .commits[]
    | "  - \(.commit.message | split("\n")[0] | gsub("#(?<n>[0-9]+)"; "\($repo)#\(.n)")) (\(.sha[0:7]))"')" \
  || [ -z "${commits}" ]; then
  echo "- Upstream changes: ${compare}"
  exit 0
fi

echo "- Upstream changes ([${old_rev:0:7}...${new_rev:0:7}](${compare})):"
echo "${commits}"
