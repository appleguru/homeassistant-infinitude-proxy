#!/bin/sh
# Entrypoint for the Infinitude Home Assistant app.
#
# POSIX sh only: the upstream image is Alpine (busybox sh), with no bash.
#
# Keeps runtime state under /data so it survives app restarts, updates
# and rebuilds, and is captured by Home Assistant backups.
set -eu

OPTIONS_FILE="/data/options.json"
STATE_DIR="/data/state"
CONFIG_FILE="/data/infinitude.json"
APP_DIR="/infinitude"
HELPER="/opt/infinitude-app/render-options.pl"

log() { echo "[infinitude-app] $*"; }

if [ ! -f "${OPTIONS_FILE}" ]; then
    log "ERROR: ${OPTIONS_FILE} not found. Is this running as a Home Assistant app?"
    exit 1
fi

# Move state out of the container's writable layer and into /data.
mkdir -p "${STATE_DIR}"
if [ -d "${APP_DIR}/state" ] && [ ! -L "${APP_DIR}/state" ]; then
    if [ -n "$(ls -A "${APP_DIR}/state" 2>/dev/null)" ]; then
        log "Seeding ${STATE_DIR} from the image's bundled state directory"
        if ! cp -a "${APP_DIR}/state/." "${STATE_DIR}/"; then
            log "ERROR: failed to seed ${STATE_DIR} from ${APP_DIR}/state"
            exit 1
        fi
    fi
    rm -rf "${APP_DIR}/state"
fi
ln -sfn "${STATE_DIR}" "${APP_DIR}/state"

if [ -f "${APP_DIR}/infinitude.json" ] && [ ! -L "${APP_DIR}/infinitude.json" ]; then
    if [ ! -e "${CONFIG_FILE}" ]; then
        log "Seeding ${CONFIG_FILE} from the image's bundled config"
        cp -a "${APP_DIR}/infinitude.json" "${CONFIG_FILE}"
    fi
    rm -f "${APP_DIR}/infinitude.json"
fi
ln -sfn "${CONFIG_FILE}" "${APP_DIR}/infinitude.json"

# The helper writes infinitude.json and echoes "<port> <mode>".
if ! HELPER_OUT="$(perl "${HELPER}")"; then
    log "ERROR: ${HELPER} failed"
    exit 1
fi

set -- ${HELPER_OUT}
if [ "$#" -ne 2 ]; then
    log "ERROR: ${HELPER} returned unexpected output: ${HELPER_OUT}"
    exit 1
fi
PORT="$1"
MODE="$2"

log "Starting infinitude (mode=${MODE}, port=${PORT}, state=${STATE_DIR})"

cd "${APP_DIR}"
exec ./infinitude daemon -m "${MODE}" -l "http://*:${PORT}"
