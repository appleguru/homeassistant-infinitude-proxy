#!/bin/sh
# Entrypoint for the Infinitude Home Assistant add-on.
#
# POSIX sh only: the upstream image is Alpine (busybox sh), with no bash.
#
# Keeps runtime state under /data so it survives add-on restarts, updates
# and rebuilds, and is captured by Home Assistant backups.
set -eu

OPTIONS_FILE="/data/options.json"
STATE_DIR="/data/state"
APP_DIR="/infinitude"
HELPER="/opt/infinitude-addon/render-options.pl"

log() { echo "[infinitude-addon] $*"; }

if [ ! -f "${OPTIONS_FILE}" ]; then
    log "ERROR: ${OPTIONS_FILE} not found. Is this running as a Home Assistant add-on?"
    exit 1
fi

# Move state out of the container's writable layer and into /data.
mkdir -p "${STATE_DIR}"
if [ -d "${APP_DIR}/state" ] && [ ! -L "${APP_DIR}/state" ]; then
    if [ -n "$(ls -A "${APP_DIR}/state" 2>/dev/null)" ]; then
        log "Seeding ${STATE_DIR} from the image's bundled state directory"
        cp -a "${APP_DIR}/state/." "${STATE_DIR}/" 2>/dev/null || true
    fi
    rm -rf "${APP_DIR}/state"
fi
ln -sfn "${STATE_DIR}" "${APP_DIR}/state"

# The helper writes infinitude.json and echoes "<port> <mode>".
set -- $(perl "${HELPER}")
PORT="$1"
MODE="$2"

log "Starting infinitude (mode=${MODE}, port=${PORT}, state=${STATE_DIR})"

cd "${APP_DIR}"
exec ./infinitude daemon -m "${MODE}" -l "http://*:${PORT}"
