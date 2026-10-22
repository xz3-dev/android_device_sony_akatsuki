#
# SPDX-FileCopyrightText: 2026 xz3-dev
# SPDX-License-Identifier: Apache-2.0
#
# Google apps from vendor/gms (PixelOS vendor_gms-15, Android 15 QPR2), a selection of its
# packages instead of its full product configuration. The Google modules carry Soong
# overrides that drop the LineageOS apps they replace (Trebuchet, Dialer, messaging,
# Contacts, DeskClock, ExactCalculator, LatinIME, ThemePicker, Provision,
# OneTimeInitializer, QuickSearchBox).
#

XZ3_GMS_PATH := vendor/gms/common/proprietary

ifeq ($(wildcard vendor/gms/common/Android.bp),)
$(error vendor/gms is missing, sync the local manifest or build with WITH_GMS=false)
endif

# repo sync without Git LFS leaves pointer files instead of APKs.
ifneq ($(shell head -c 64 $(XZ3_GMS_PATH)/product/priv-app/Phonesky/Phonesky.apk | grep -c git-lfs),0)
$(error vendor/gms holds Git LFS pointers, run "repo forall vendor/gms -c git lfs pull")
endif

PRODUCT_SOONG_NAMESPACES += \
    vendor/gms/common

# Core: Play services, Play Store, Services Framework, setup and restore
PRODUCT_PACKAGES += \
    ConfigUpdater \
    GoogleOneTimeInitializer \
    GoogleRestorePrebuilt-v636048 \
    GoogleServicesFramework \
    PartnerSetupPrebuilt \
    Phonesky \
    PrebuiltGmsCore \
    SetupWizardPrebuilt

# Pixel Launcher; At a Glance and the app search come from Android System
# Intelligence, which reaches the network through Private Compute Services.
PRODUCT_PACKAGES += \
    DeviceIntelligenceNetworkPrebuilt-U.32_V.7_playstore_astrea_20240725.00_RC01 \
    DevicePersonalizationPrebuiltPixel2024-U.32_V.7_playstore_aiai_20240725.00_RC08 \
    NexusLauncherRelease

# Google app, Phone, Messages, Contacts, Clock, Calculator, Gboard
PRODUCT_PACKAGES += \
    CalculatorGooglePrebuilt_85005407 \
    GoogleContacts \
    GoogleDialer \
    LatinIMEGooglePrebuilt \
    PrebuiltBugle \
    PrebuiltDeskClockGoogle_76006071 \
    Velvet \
    com.google.android.dialer.support

# Wallpaper & style, Pixel wallpapers and themes
PRODUCT_PACKAGES += \
    PixelThemesStub \
    PixelThemesStub2022_and_newer \
    PixelWallpapers2024 \
    WallpaperPickerGoogleRelease

# Configuration
PRODUCT_PACKAGES += \
    XZ3GmsFrameworkOverlay \
    XZ3GmsTeleServiceOverlay \
    XZ3GmsTelecomOverlay

PRODUCT_COPY_FILES += \
    $(XZ3_GMS_PATH)/product/etc/default-permissions/default-permissions.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions.xml \
    $(XZ3_GMS_PATH)/product/etc/permissions/com.google.android.dialer.support.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.google.android.dialer.support.xml \
    $(XZ3_GMS_PATH)/product/etc/permissions/privapp-permissions-google-p.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google-p.xml \
    $(XZ3_GMS_PATH)/product/etc/permissions/split-permissions-google.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/split-permissions-google.xml \
    $(XZ3_GMS_PATH)/product/etc/preferred-apps/google.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/preferred-apps/google.xml \
    $(XZ3_GMS_PATH)/product/etc/security/fsverity/gms_fsverity_cert.der:$(TARGET_COPY_OUT_PRODUCT)/etc/security/fsverity/gms_fsverity_cert.der \
    $(XZ3_GMS_PATH)/product/etc/security/fsverity/play_store_fsi_cert.der:$(TARGET_COPY_OUT_PRODUCT)/etc/security/fsverity/play_store_fsi_cert.der \
    $(XZ3_GMS_PATH)/product/etc/sysconfig/google-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-hiddenapi-package-whitelist.xml \
    $(XZ3_GMS_PATH)/product/etc/sysconfig/google-staged-installer-whitelist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-staged-installer-whitelist.xml \
    $(XZ3_GMS_PATH)/product/etc/sysconfig/google.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google.xml \
    $(XZ3_GMS_PATH)/product/etc/sysconfig/google_build.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google_build.xml \
    $(XZ3_GMS_PATH)/system_ext/etc/permissions/privapp-permissions-google-se.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-google-se.xml \
    device/sony/akatsuki/gms/permissions/privapp-permissions-xz3-gms.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-xz3-gms.xml \
    device/sony/akatsuki/gms/sysconfig/pixel-experience-xz3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel-experience-xz3.xml

PRODUCT_PRODUCT_PROPERTIES += \
    ro.opa.eligible_device=true

# Gboard: Material You theme
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.bs_theme=true \
    ro.com.google.ime.theme_id=5

# Setup wizard (LineageOS already sets setupwizard.theme and day/night mode)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.enterprise_mode=1 \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    setupwizard.feature.enable_restore_anytime=true \
    setupwizard.feature.enable_wifi_tracker=true \
    setupwizard.feature.lifecycle_refactoring=true \
    setupwizard.feature.notification_refactoring=true \
    setupwizard.feature.portal_notification=true

# Google Sans as the system font (vendor/pixel/gsans)
ifneq ($(XZ3_GOOGLE_SANS),false)
ifeq ($(wildcard vendor/pixel/gsans/common/common-vendor.mk),)
$(error vendor/pixel/gsans is missing, sync the local manifest or build with XZ3_GOOGLE_SANS=false)
endif
$(call inherit-product, vendor/pixel/gsans/common/common-vendor.mk)
PRODUCT_PACKAGES += \
    XZ3GoogleSansOverlay \
    fonts_customization.google-sans
endif

# Pixel boot animation (vendor/sony/xz3)
ifneq ($(XZ3_PIXEL_BOOTANIMATION),false)
ifneq ($(wildcard vendor/sony/xz3/pixel/bootanimation.zip),)
TARGET_BOOTANIMATION := vendor/sony/xz3/pixel/bootanimation.zip
endif
endif
