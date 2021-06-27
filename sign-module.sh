#!/bin/bash
set -e

KVER="$(make -s -C /usr/src/linux kernelversion 2>/dev/null)"
BUILD_DIR="/usr/src/build-${KVER}"
SRC_DIR=/usr/src/linux
SCRIPTS_DIR="${BUILD_DIR}/scripts"

SIGN_FILE="${SCRIPTS_DIR}/sign-file"

exec "${SIGN_FILE}" sha512 /etc/efikeys/db.combined.key /etc/efikeys/db.crt "${1}"
