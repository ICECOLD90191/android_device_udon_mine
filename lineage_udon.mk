#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

#-----------------------------------------------------------------------------
# Core Android Product Configuration
#-----------------------------------------------------------------------------
# Inherit from the core 64-bit product definition.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
# Inherit from the full phone product definition, which includes telephony.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)


#-----------------------------------------------------------------------------
# LineageOS Specific Configuration
#-----------------------------------------------------------------------------
# This line will pull in all the common APNs for cell carriers.
# NOTE: This file will only exist once you have the full LineageOS source code.
# For now, we are including it so the file is ready for the final build.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)


#-----------------------------------------------------------------------------
# Device Specific Configuration
#-----------------------------------------------------------------------------
# Inherit from our own device-specific configuration file.
# This is where we will define packages and properties unique to 'udon'.
$(call inherit-product, device/oneplus/udon/device.mk)


#-----------------------------------------------------------------------------
# Product Identity
#-----------------------------------------------------------------------------
# These values are pulled directly from your device's properties.
PRODUCT_NAME := lineage_udon
PRODUCT_DEVICE := udon
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := CPH2487

# This is used for Google apps to identify the device.
PRODUCT_GMS_CLIENTID_BASE := android-oneplus
