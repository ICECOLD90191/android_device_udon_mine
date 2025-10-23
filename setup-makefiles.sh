#!/bin/bash
#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Required!
DEVICE=udon
VENDOR=oneplus

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

HELPER="extract_utils.sh"

if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# --- THIS IS THE MODIFIED LINE ---
# Default to NOT sanitizing the vendor folder. Clean only if explicitly asked.
CLEAN_VENDOR=false
# --- END MODIFICATION ---

LINEAGE_ROOT="${MY_DIR}/../../.."

# --- NEW: Add logic for an explicit clean flag if needed ---
CLEAN_REQUESTED=false
# --- END NEW ---

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        # Keep the --no-clean flag for compatibility, though it's now the default
        -n | --no-clean )
                CLEAN_VENDOR=false
                ;;
        # --- NEW: Add an explicit --clean flag ---
        -c | --clean )
                CLEAN_VENDOR=true
                CLEAN_REQUESTED=true # Track that cleaning was explicitly requested
                ;;
        # --- END NEW ---
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                # We are not using sections, but keep the logic
                extract_section "${2}"; shift
                CLEAN_VENDOR=false # Don't clean when processing sections
                ;;
        * )
                SECTION="${1}"
                ;;
    esac
    shift
done

# --- NEW: Ensure CLEAN_VENDOR respects explicit --clean flag ---
# If --clean was explicitly passed, make sure CLEAN_VENDOR is true
if ${CLEAN_REQUESTED}; then
    CLEAN_VENDOR=true
fi
# --- END NEW ---


if [ -z "${SECTION}" ]; then
    SECTION=proprietary-files.txt
fi

# Create a dummy proprietary-files-list.sh to satisfy the helper script
(
    cat << EOF
#!/bin/bash
#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This file is a placeholder to satisfy the setup script.
#
EOF
) > "${MY_DIR}/proprietary-files-list.sh"

chmod +x "${MY_DIR}/proprietary-files-list.sh"

# Initialize the helper for device
# The CLEAN_VENDOR variable is passed here, now defaulting to false
setup_vendor "${DEVICE}" "${VENDOR}" "${LINEAGE_ROOT}" false "${CLEAN_VENDOR}"

echo "Generating product makefiles..."
echo "Done."

# --- NEW: Clean up the dummy script ---
rm -f "${MY_DIR}/proprietary-files-list.sh"
# --- END NEW ---
