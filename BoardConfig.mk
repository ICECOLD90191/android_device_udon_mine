#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# This file is the low-level hardware blueprint for the OnePlus 11R (udon).
# It is built from live data pulled from the device's stock ROM.
#

#-----------------------------------------------------------------------------
# Architecture
#-----------------------------------------------------------------------------
# Snapdragon 8+ Gen 1 (taro) is an ARMv8-A based chipset
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT_RUNTIME := cortex-a710

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a510


#-----------------------------------------------------------------------------
# Platform & Bootloader
#-----------------------------------------------------------------------------
# From getprop ro.board.platform
TARGET_BOARD_PLATFORM := taro
TARGET_BOOTLOADER_BOARD_NAME := udon
TARGET_NO_BOOTLOADER := true


#-----------------------------------------------------------------------------
# Kernel
#-----------------------------------------------------------------------------
# From cat /proc/cmdline
BOARD_KERNEL_CMDLINE := stack_depot_disable=on kasan.stacktrace=off kvm-arm.mode=protected cgroup_disable=pressure cgroup.memory=nokmem console=ttyMSM0,115200n8 loglevel=6 kpti=0 log_buf_len=2M kernel.panic_on_rcu_stall=1 swiotlb=noforce loop.max_part=7 cgroup.memory=nokmem,nosocket pcie_ports=compat msm_rtb.filter=0x237 allow_mismatched_32bit_el0 kasan=off rcupdate.rcu_expedited=1 rcu_nocbs=0-7 ftrace_dump_on_oops pstore.compress=none cpufreq.default_governor=performance can.stats_timer=0 fsa4480_i2c.async_probe=1 slub_debug=- disable_dma32=on video=vfb:640x400,bpp=32,memsize=3072000 msm_geni_serial.con_enabled=0 bootconfig buildvariant=user
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096

# Device has a separate vendor_boot partition, requiring header version 4
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# We will add the prebuilt kernel path here later.
# TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/prebuilt/Image


#-----------------------------------------------------------------------------
# Partitions & Filesystem
#-----------------------------------------------------------------------------
# Enable A/B (Seamless) Updates with Virtual A/B
AB_OTA_UPDATES := true

# Use Dynamic Partitions (Super) - Data from 'lpdump'
BOARD_SUPER_PARTITION_SIZE := 11190403072
BOARD_OPLUS_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor odm
# The build system will automatically reserve space for all other proprietary 'my_*' partitions.
BOARD_SUPER_PARTITION_GROUPS := oneplus_dynamic_partitions
BOARD_ONEPLUS_DYNAMIC_PARTITIONS_SIZE := 7511998464

# Define the size of each AOSP logical partition inside Super.
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 705691648
BOARD_SYSTEMEXTIMAGE_PARTITION_SIZE := 1083596800
BOARD_PRODUCTIMAGE_PARTITION_SIZE := 2867200
BOARD_VENDORIMAGE_PARTITION_SIZE := 671313920
BOARD_ODMIMAGE_PARTITION_SIZE := 1600000000 # Minor Note 1 (See below)

# Physical partition sizes calculated from /proc/partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_USERDATAIMAGE_PARTITION_SIZE := 108616806400

BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)

# Enable filesystem tools for building and flashing
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true


#-----------------------------------------------------------------------------
# Recovery
#-----------------------------------------------------------------------------
# Path to the FSTAB file
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/rootdir/etc/fstab.qcom

# Enable Fingerprint-On-Display (FOD) support in recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 120
TARGET_USES_FOD := true


#-----------------------------------------------------------------------------
# Vendor
#-----------------------------------------------------------------------------
# Soong namespace for our device tree
BOARD_VENDOR_SOONG_NAMESPACE := $(LOCAL_PATH)
# Target for vendor files
TARGET_COPY_OUT_VENDOR := vendor
