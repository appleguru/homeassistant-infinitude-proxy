#!/usr/bin/env python3
"""Prepend a CHANGELOG entry built from upstream release notes on stdin.

Usage: changelog-entry.py <version> < notes.md
"""
import os
import re
import sys

CHANGELOG = "infinitude/CHANGELOG.md"

version = sys.argv[1]
repo = os.environ.get("UPSTREAM_REPO", "nebulous/infinitude")
url = f"https://github.com/{repo}/releases/tag/{version}"

notes = sys.stdin.read().replace("\r\n", "\n").strip()
# Nest upstream headings under our "## <version>" heading, and point bare
# issue references at the upstream repository instead of this one.
notes = re.sub(r"^(#+ )", r"##\1", notes, flags=re.M)
notes = re.sub(r"(?<![\w/&#])#(\d+)\b", rf"{repo}#\1", notes)

entry = f"## {version}\n\nUpstream release notes: {url}\n"
if notes:
    entry += f"\n{notes}\n"

with open(CHANGELOG, encoding="utf-8") as f:
    body = f.read()
if not body.startswith("# Changelog\n\n"):
    sys.exit(f"{CHANGELOG} does not start with '# Changelog'")
with open(CHANGELOG, "w", encoding="utf-8") as f:
    f.write(body.replace("# Changelog\n\n", f"# Changelog\n\n{entry}\n", 1))
