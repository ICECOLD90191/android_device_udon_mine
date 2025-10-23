#!/bin/bash
#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This on-device helper script copies files, preserves permissions,
# shows progress, reports failures, and correctly handles Makefile variables.
#

function extract_files() {
    local SRC="$1"
    local VENDOR_DIR="$2"
    local PROPRIETARY_FILES_TXT="${MY_DIR}/proprietary-files.txt"

    if [ ! -f "${PROPRIETARY_FILES_TXT}" ]; then
        echo "Error: proprietary-files.txt not found!"
        return 1
    fi

    echo "Starting extraction with root privileges..."
    su -c echo "Root access confirmed."

    local TOTAL_FILES=$(grep -v -e '^#' -e '^\s*$' "${PROPRIETARY_FILES_TXT}" | wc -l)
    local CURRENT_FILE_COUNT=0
    local SUCCESS_COUNT=0
    local FAIL_COUNT=0
    local FAILED_FILES=()

    while IFS= read -r line; do
        if [[ "${line}" =~ ^# ]] || [[ -z "${line}" ]]; then
            continue
        fi
        if [[ "${line}" =~ ^- ]]; then
            continue
        fi

        CURRENT_FILE_COUNT=$((CURRENT_FILE_COUNT + 1))

        if [[ "${line}" == */ ]]; then
            local src_dir="${SRC}/${line}"
            local dest_dir_parent="${VENDOR_DIR}/${VENDOR}/${DEVICE}/$(dirname "${line}")"
            mkdir -p "${dest_dir_parent}"
            echo -ne "[${CURRENT_FILE_COUNT}/${TOTAL_FILES}] Copying DIR: ${line} ... "
            if su -c "cp -a '${src_dir}' '${dest_dir_parent}/'" < /dev/null; then
                echo "OK"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo "FAIL"
                FAIL_COUNT=$((FAIL_COUNT + 1))
                FAILED_FILES+=("${src_dir}")
            fi
            continue
        fi

        local src_file=$(echo "${line}" | cut -d':' -f1)
        
        # --- THIS IS THE FIX for Makefile variables ---
        local dest_file_raw=$(echo "${line}" | cut -d':' -f2)
        local dest_file=$(echo "${dest_file_raw}" | \
            sed 's|$(TARGET_COPY_OUT_VENDOR)|vendor|g' | \
            sed 's|$(TARGET_COPY_OUT_ODM)|odm|g')
        # --- END FIX ---

        if [ "${src_file}" == "${dest_file}" ]; then
            dest_file="${src_file}"
        fi

        local full_src_path="${SRC}/${src_file}"
        local dest_dir=$(dirname "${VENDOR_DIR}/${VENDOR}/${DEVICE}/${dest_file}")

        echo -ne "[${CURRENT_FILE_COUNT}/${TOTAL_FILES}] Copying: ${src_file} ... "

        if su -c "test -e '${full_src_path}'" < /dev/null; then
            mkdir -p "${dest_dir}"
            if su -c "cp -a '${full_src_path}' '${dest_dir}/${dest_file##*/}'" < /dev/null; then
                echo "OK"
                SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
            else
                echo "FAIL"
                FAIL_COUNT=$((FAIL_COUNT + 1))
                FAILED_FILES+=("${full_src_path}")
            fi
        else
            echo "MISSING"
            FAIL_COUNT=$((FAIL_COUNT + 1))
            FAILED_FILES+=("${full_src_path}")
        fi
    done < "${PROPRIETARY_FILES_TXT}"

    echo ""
    echo "---------------------------"
    echo "Extraction Summary:"
    echo "---------------------------"
    echo "Successfully copied: ${SUCCESS_COUNT} / ${TOTAL_FILES} files."
    echo "Missing or failed: ${FAIL_COUNT} files."

    if [ ${FAIL_COUNT} -gt 0 ]; then
        echo ""
        echo "List of Missing/Failed Files:"
        for failed_file in "${FAILED_FILES[@]}"; do
            echo "  - ${failed_file}"
        done
    fi
    echo "---------------------------"

    if [ ${FAIL_COUNT} -eq 0 ]; then
        echo "Extraction completed successfully!"
    else
        echo "Extraction completed with some missing files. Please review the list above."
    fi
}
