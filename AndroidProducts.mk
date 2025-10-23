#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This file registers our device with the build system.
# It points to the main makefile that defines the product.
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/lineage_udon.mk

COMMON_LUNCH_CHOICES := \
    lineage_udon-user \
    lineage_udon-userdebug \
    lineage_udon-eng
