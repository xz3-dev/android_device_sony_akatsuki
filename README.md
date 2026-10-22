# Device Tree for Xperia XZ3 (akatsuki)
The Xperia (codenamed _"akatsuki"_) is a smartphone from Sony Mobile.
It was released in 2018.

| Basic                   | Spec Sheet                                                                                                                     |
| -----------------------:|:------------------------------------------------------------------------------------------------------------------------------ |
| CPU                     | Octa-core (4x2.8 GHz Kryo 385 Gold & 4x1.7 GHz Kryo 385 Silver)                                                                |
| Chipset                 | Qualcomm SDM845 Snapdragon 845                                                                                                 |
| GPU                     | Adreno 630                                                                                                                     |
| Memory                  | 4/6 GB RAM                                                                                                                     |
| Shipped Android Version | 9.0                                                                                                                            |
| Storage                 | 64 GB                                                                                                                  |
| Battery                 | Non-removable Li-Po 3300 mAh battery                                                                                           |
| Display                 | Toppest p-OLED, 1440 x 2880 pixels, 18:9 ratio (~537 ppi density)                                                                |
| Camera (Back)           | 19 MP (f/2.0, 25mm, 1/2.3", 1.22 µm), gyro EIS, predictive phase detection and laser AF, LED flash, 4K at 30fps, 1080p at 30, 60fps or 960fps |
| Camera (Front)          | 13 MP (f/1.9, 1/3.1"), gyro EIS, 1080p                                                                    |

Copyright 2018 - The LineageOS Project.

![Xperia XZ3](https://fdn2.gsmarena.com/vv/pics/sony/sony-xperia-xz3-1.jpg "Xperia XZ3")


## Temporary build instructions

```
# Compiling
$ m[ake|ka] bootimage systemimage

# Installing
$ fastboot --disable-verity --disable-verification flash vbmeta stock_vbmeta.img
$ fastboot flash boot boot.img
$ fastboot flash system system.img
$ fastboot -w reboot
```


## 801SO build (branch `lineage-22.2-xz3`)

This branch targets the SoftBank **801SO** and is synced with the local manifest
from [xz3-dev/manifest](https://github.com/xz3-dev/manifest). On top of
`lineage-22.2`:

- **NFC**: Sony CXD224x controller (Carillon driver in
  xz3-dev/android_kernel_sony_sdm845) with the 801SO HIDL NFC HAL 1.2,
  `snfcboot`, firmware and configuration from `vendor/sony/xz3`. The NXP stack
  is not built (`TARGET_USES_SONY_CXD224X_NFC`). The global models (H8416,
  H9436, H9493) have no working NFC with this branch.
- **Tap to wake**: `config_supportDoubleTapWake`; the power HAL switches
  `/sys/devices/virtual/input/lge_touch/tap_to_wake` (tama-common).
- **Dolby Atmos**: DMS HAL 2.0 init script, VINTF entries and enforcing
  sepolicy; blobs and apps in `vendor/sony/xz3`.
- **Camera**: GCam (`com.android.MGC_9_6_080.xz3`) replaces Aperture and is used
  for the lock screen and power key shortcuts; the Sony camera provider loads
  the RAW bridge `libcaminject.so` (`vendor/sony/xz3`).
- **Camera button, notification light**: XperiaParts in tama-common
  (Settings > System > Gestures > Camera button, Settings > Notifications >
  Light for all notifications).
- **Display modes**: LiveDisplay from tama-common (Professional, Standard,
  Super-vivid).
- **Updates**: `lineage.updater.uri` is built from `XZ3_OTA_HOST` in
  `device.mk`.
- **Google apps** (`WITH_GMS`, default `true`): `gms/gms.mk` installs a selection
  of the PixelOS `vendor_gms-15` prebuilts (`vendor/gms`, Git LFS): Play
  services, Play Store, Services Framework, setup wizard and restore, Pixel
  Launcher with Android System Intelligence and Private Compute Services, the
  Google app, Phone (call recording feature), Messages, Contacts, Clock,
  Calculator, Gboard, Wallpaper & style, Pixel wallpapers and themes. Their
  Soong overrides remove Trebuchet, Dialer, messaging, Contacts, DeskClock,
  ExactCalculator, LatinIME and ThemePicker. Configuration (default apps,
  launcher services, Pixel features up to 2020) lives in `gms/overlay` and
  `gms/sysconfig`; no Google binaries are in this repository.
  `XZ3_GOOGLE_SANS=false` drops Google Sans (`vendor/pixel/gsans`),
  `XZ3_PIXEL_BOOTANIMATION=false` keeps the LineageOS boot animation.

`vendor/sony/xz3` is private; see its README for `scripts/fetch-prebuilts.sh`,
which has to run before `breakfast`.
