#!/bin/bash
#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This script extracts proprietary files from a live device.
#

set -e

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

# The root of our project (our home directory)
LINEAGE_ROOT=~/
DEVICE=udon
VENDOR=oneplus

# Source the common extraction script which contains the main logic
source "${MY_DIR}/common/extract-files-common.sh"

# Run the extraction from the live system ("/") to our vendor directory
extract_files "/" "${LINEAGE_ROOT}/vendor"
