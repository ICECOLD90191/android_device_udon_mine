#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This file is built based on the lshal dump from the stock OxygenOS 13.1 ROM.
#

#-----------------------------------------------------------------------------
# Inherit from the proprietary vendor repository
#-----------------------------------------------------------------------------
$(call inherit-product, vendor/oneplus/udon/udon-vendor.mk)
# Inherit from the common oem 
$(call inherit-product, device/oneplus/sm8450-common/common.mk)


#-----------------------------------------------------------------------------
# Core Packages & Services
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-impl \
    android.hardware.ir@1.0-service \
    libjson \
    libtinyxml \
    OplusParts


#-----------------------------------------------------------------------------
# Audio & Dolby Atmos
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl \
    audio.primary.lahaina \
    audio.bluetooth.default \
    audio.r_submix.default \
    libqcompostprocbundle \
    libqti-audio-utils \
    libvolumelistener \
    vendor.oplus.hardware.virtual_device.audio@1.0.so \
    DolbyAtmos


#-----------------------------------------------------------------------------
# Biometrics (In-Display Fingerprint)
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service \
    vendor.oplus.hardware.biometrics.fingerprint@2.1-service


#-----------------------------------------------------------------------------
# Bluetooth
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service-qti \
    vendor.oplus.hardware.bluetooth_audio_extend@2.1.so \
    vendor.qti.hardware.bluetooth_audio@2.1.so


#-----------------------------------------------------------------------------
# Connectivity & GPS
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-service-qti \
    android.hardware.nfc@1.2-service \
    vendor.oplus.hardware.felica@1.0.so


#-----------------------------------------------------------------------------
# Display & Graphics
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    vendor.display.config@2.0 \
    libdisplayconfig.qti \
    libsdmcore \
    libsdmutils \
    vendor.oplus.hardware.displaypanelfeature@1.0.so \
    vendor.oplus.hardware.mmdisplayfeature@1.0.so


#-----------------------------------------------------------------------------
# Power, Charging & Thermal
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service \
    vendor.oplus.hardware.charger@1.0-service


#-----------------------------------------------------------------------------
# Radio / Telephony
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    vendor.oplus.hardware.appradio@1.0.so \
    vendor.oplus.hardware.ims@1.0.so \
    vendor.oplus.hardware.radio@1.0.so


#-----------------------------------------------------------------------------
# Wi-Fi
#-----------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.5-service \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf


#-----------------------------------------------------------------------------
# Overlays & Permissions
#-----------------------------------------------------------------------------
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/oneplus/udon/configs/permissions,$(TARGET_COPY_OUT_VENDOR)/etc/permissions) \
    frameworks/native/config/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml


#-----------------------------------------------------------------------------
# System Properties
#-----------------------------------------------------------------------------
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=560 \
    ro.surface_flinger.supports_layer_fod=1 \
    persist.sys.sf.native_mode=1


#-----------------------------------------------------------------------------
# Boot Animation
#-----------------------------------------------------------------------------
TARGET_SCREEN_HEIGHT := 2772
TARGET_SCREEN_WIDTH := 1240
TARGET_BOOT_ANIMATION_RES := 1440
