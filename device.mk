#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_p.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/sony/akatsuki/akatsuki-vendor.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 2880
TARGET_SCREEN_WIDTH := 1440

# Camera
# GCam from vendor/sony/xz3 is the camera app; this drops Aperture.
PRODUCT_NO_CAMERA := true

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage/lineage-sdk

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Inherit from tama-common
$(call inherit-product, device/sony/tama-common/common.mk)

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(LOCAL_PATH)/audio/mixer_paths_tavil.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_tavil.xml \
    $(LOCAL_PATH)/audio/sound_trigger_mixer_paths_wcd9340.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths_wcd9340.xml \
    $(LOCAL_PATH)/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml

# Dolby
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.dolby.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.dolby.rc

# Input
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/idc/sidekey_dev.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/sidekey_dev.idc \
    $(LOCAL_PATH)/idc/touch_dev.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/touch_dev.idc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl

# NFC
# The 801SO has a Sony CXD224x controller instead of the NXP PN553 of the global models.
TARGET_USES_SONY_CXD224X_NFC := true

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.nfc.cxd224x.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.nfc.cxd224x.rc

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf
