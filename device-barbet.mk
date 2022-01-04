#
# Copyright 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_HARDWARE := barbet

ifeq ($(TARGET_PREBUILT_KERNEL),)
    ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
        LOCAL_KERNEL := device/google/barbet/prebuilts/kernel/Image.lz4-redfin
    else
        LOCAL_KERNEL := device/google/barbet-kernel/vintf/Image.lz4
    endif
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_VENDOR_KERNEL_HEADERS := device/google/barbet/kernel-headers

DEVICE_PACKAGE_OVERLAYS += device/google/barbet/barbet/overlay

PRODUCT_DEVICE_SVN_OVERRIDE := true

include build/make/target/product/iorap_large_memory_config.mk
include device/google/redbull/device-common.mk

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Increment the SVN for any official public releases
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.svn=14

# Enable watchdog timeout loop breaker.
PRODUCT_PROPERTY_OVERRIDES += \
    framework_watchdog.fatal_window.second=600 \
    framework_watchdog.fatal_count=3

# Enable zygote critical window.
PRODUCT_PROPERTY_OVERRIDES += \
    zygote.critical_window.minute=10

# LOCAL_PATH is device/google/redbull before this
LOCAL_PATH := device/google/barbet

PRODUCT_SOONG_NAMESPACES += \
    device/google/barbet

PRODUCT_PACKAGES += \
    libtasspkrprot

# Audio XMLs for barbet
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/mixer_paths_bolero_snd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_bolero_snd.xml \
    $(LOCAL_PATH)/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/audio/audio_platform_info_bolero_snd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info_bolero_snd.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration_a2dp_offload_disabled.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_a2dp_offload_disabled.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration_bluetooth_legacy_hal.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration_bluetooth_legacy_hal.xml \
    $(LOCAL_PATH)/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/audio/tas2562/tas25xx_TI_0.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/tas25xx_TI_0.bin \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/hearing_aid_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/hearing_aid_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Audio ACDB data
ifeq ($(wildcard vendor/google_cei/factory/prebuilt/ftm.mk),)
PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/audio/acdbdata/Bluetooth_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Bluetooth_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/General_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/General_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/Global_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Global_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/Handset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Handset_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/Hdmi_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Hdmi_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/Headset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Headset_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/Speaker_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/Speaker_cal.acdb \
     $(LOCAL_PATH)/audio/acdbdata/adsp_avs_config.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/adsp_avs_config.acdb

# Audio ACDB workspace files for QACT
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/audio/acdbdata/workspaceFile.qwsp:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/workspaceFile.qwsp
endif
endif

# Calibration Tools for factory
ifneq ($(wildcard vendor/google_cei/factory/prebuilt/ftm.mk),)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/tas2562/calib.config:$(TARGET_COPY_OUT_VENDOR)/etc/calib.config \
    $(LOCAL_PATH)/audio/tas2562/PinkNoise_m22db_RmsPow.wav:$(TARGET_COPY_OUT_VENDOR)/etc/PinkNoise_m22db_RmsPow.wav \
    $(LOCAL_PATH)/audio/tas2562/Silence.wav:$(TARGET_COPY_OUT_VENDOR)/etc/Silence.wav \
    $(LOCAL_PATH)/audio/tas2562/TAS_FactoryApp:$(TARGET_COPY_OUT_VENDOR)/bin/TAS_FactoryApp
endif

ifeq ($(wildcard vendor/google_devices/barbet/proprietary/device-vendor-barbet.mk),)
    BUILD_WITHOUT_VENDOR := true
endif

PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.barbet

# Vibrator HAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.barbet

# DRV2624 Haptics Waveform
PRODUCT_COPY_FILES += \
    device/google/barbet/vibrator/drv2624/drv2624.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/drv2624.bin

# Vibrator HAL
PRODUCT_PRODUCT_PROPERTIES +=\
    ro.vendor.vibrator.hal.config.dynamic=1 \
    ro.vendor.vibrator.hal.click.duration=7 \
    ro.vendor.vibrator.hal.tick.duration=7 \
    ro.vendor.vibrator.hal.heavyclick.duration=7 \
    ro.vendor.vibrator.hal.short.voltage=161 \
    ro.vendor.vibrator.hal.long.voltage=161 \
    ro.vendor.vibrator.hal.long.frequency.shift=10 \
    ro.vendor.vibrator.hal.steady.shape=1 \
    ro.vendor.vibrator.hal.lptrigger=0


# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.1-service.barbet

#per device
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/barbet/init.barbet.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.barbet.rc

# insmod files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.insmod.barbet.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.barbet.cfg

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.device.rc:recovery/root/init.recovery.barbet.rc

# TWRP
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc \
    $(LOCAL_PATH)/prebuilts/touchscreen/ftm5.ko-redfin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/ftm5.ko \
    $(LOCAL_PATH)/prebuilts/touchscreen/sec_touch.ko-redfin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib/modules/1.1/sec_touch.ko \
    $(LOCAL_PATH)/prebuilts/touchdriver.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/touchdriver.sh \
    $(LOCAL_PATH)/prebuilts/android.hardware.gatekeeper@1.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.gatekeeper@1.0-service-qti \
    $(LOCAL_PATH)/prebuilts/android.hardware.keymaster@4.1-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@4.1-service.citadel \
    $(LOCAL_PATH)/prebuilts/citadeld::$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/citadeld \
    $(LOCAL_PATH)/prebuilts/qseecomd::$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/qseecomd \
    $(LOCAL_PATH)/prebuilts/android.hardware.keymaster@4.0-service-qti:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.keymaster@4.0-service-qti \
    $(LOCAL_PATH)/prebuilts/android.hardware.weaver@1.0-service.citadel:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/android.hardware.weaver@1.0-service.citadel \
    $(LOCAL_PATH)/prebuilts/time_daemon:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/time_daemon \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.1.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.1.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.5.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.5.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.2.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.2.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.legacy.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.legacy.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.3.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.3.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.xml \
    $(LOCAL_PATH)/prebuilts/compatibility_matrix.4.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/compatibility_matrix.4.xml \
    $(LOCAL_PATH)/prebuilts/systemmanifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/vintf/manifest.xml \
    $(LOCAL_PATH)/prebuilts/vendormanifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml \
    $(LOCAL_PATH)/prebuilts/libqtikeymaster4.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqtikeymaster4.so \
    $(LOCAL_PATH)/prebuilts/libkeymasterdeviceutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterdeviceutils.so \
    $(LOCAL_PATH)/prebuilts/libkeymasterutils.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libkeymasterutils.so \
    $(LOCAL_PATH)/prebuilts/libnosprotos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnosprotos.so \
    $(LOCAL_PATH)/prebuilts/vendor-pixelatoms-cpp.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/vendor-pixelatoms-cpp.so \
    $(LOCAL_PATH)/prebuilts/libQSEEComAPI.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libQSEEComAPI.so \
    $(LOCAL_PATH)/prebuilts/android.hardware.authsecret@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.authsecret@1.0-impl.nos.so \
    $(LOCAL_PATH)/prebuilts/libprotobuf-cpp-full-3.9.1.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libprotobuf-cpp-full-3.9.1.so \
    $(LOCAL_PATH)/prebuilts/libqcbor.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqcbor.so \
    $(LOCAL_PATH)/prebuilts/libdrmfs.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdrmfs.so \
    $(LOCAL_PATH)/prebuilts/libdiag.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdiag.so \
    $(LOCAL_PATH)/prebuilts/libnos_citadeld_proxy.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_citadeld_proxy.so \
    $(LOCAL_PATH)/prebuilts/libnos_client_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_client_citadel.so \
    $(LOCAL_PATH)/prebuilts/nos_app_avb.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_avb.so \
    $(LOCAL_PATH)/prebuilts/nos_app_keymaster.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_keymaster.so \
    $(LOCAL_PATH)/prebuilts/libprotobuf-cpp-lite-3.9.1.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libprotobuf-cpp-lite-3.9.1.so \
    $(LOCAL_PATH)/prebuilts/nos_app_weaver.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/nos_app_weaver.so \
    $(LOCAL_PATH)/prebuilts/libnos_datagram_citadel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos_datagram_citadel.so \
    $(LOCAL_PATH)/prebuilts/android.hardware.keymaster@4.1-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.keymaster@4.1-impl.nos.so \
    $(LOCAL_PATH)/prebuilts/android.hardware.weaver@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.weaver@1.0-impl.nos.so \
    $(LOCAL_PATH)/prebuilts/android.hardware.oemlock@1.0-impl.nos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.oemlock@1.0-impl.nos.so \
    $(LOCAL_PATH)/prebuilts/pixelpowerstats_provider_aidl_interface-V1-cpp.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/pixelpowerstats_provider_aidl_interface-V1-cpp.so \
    $(LOCAL_PATH)/prebuilts/libnos.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libnos.so \
    $(LOCAL_PATH)/prebuilts/libqmi_cci.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_cci.so \
    $(LOCAL_PATH)/prebuilts/librpmb.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/librpmb.so \
    $(LOCAL_PATH)/prebuilts/libssd.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libssd.so \
    $(LOCAL_PATH)/prebuilts/libops.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libops.so \
    $(LOCAL_PATH)/prebuilts/libdrm.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdrm.so \
    $(LOCAL_PATH)/prebuilts/libdisplayconfig.qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdisplayconfig.qti.so \
    $(LOCAL_PATH)/prebuilts/libGPreqcancel.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libGPreqcancel.so \
    $(LOCAL_PATH)/prebuilts/libqisl.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqisl.so \
    $(LOCAL_PATH)/prebuilts/libGPreqcancel_svc.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libGPreqcancel_svc.so \
    $(LOCAL_PATH)/prebuilts/vendor.display.config@2.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/vendor.display.config@2.0.so \
    $(LOCAL_PATH)/prebuilts/libdrmtime.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libdrmtime.so \
    $(LOCAL_PATH)/prebuilts/libsecureui.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libsecureui.so \
    $(LOCAL_PATH)/prebuilts/libqmi_common_so.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_common_so.so \
    $(LOCAL_PATH)/prebuilts/libStDrvInt.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libStDrvInt.so \
    $(LOCAL_PATH)/prebuilts/libtime_genoff.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libtime_genoff.so \
    $(LOCAL_PATH)/prebuilts/libqmi_encdec.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/libqmi_encdec.so \
    $(LOCAL_PATH)/prebuilts/android.hardware.gatekeeper@1.0-impl-qti.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl-qti.so \
    $(LOCAL_PATH)/prebuilts/prepdecrypt.sh:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/prepdecrypt.sh \
    $(LOCAL_PATH)/prebuilts/twrp.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags

PRODUCT_PACKAGES += \
    sensors.$(PRODUCT_HARDWARE) \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/powerhint_$(PRODUCT_HARDWARE).json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint_$(PRODUCT_HARDWARE).json

# Thermal HAL config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/thermal_info_config_$(PRODUCT_HARDWARE)_evt.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_$(PRODUCT_HARDWARE)_evt.json \
    $(LOCAL_PATH)/thermal_info_config_$(PRODUCT_HARDWARE).json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_$(PRODUCT_HARDWARE).json

# Support to disable thermal protection at run time
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/init.hardware.chamber.rc.userdebug:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.$(PRODUCT_HARDWARE).chamber.rc
endif

# Audio effects
PRODUCT_PACKAGES += \
    libqcomvoiceprocessingdescriptors

# Fingerprint HIDL
include device/google/barbet/fingerprint.mk

# NFC
PRODUCT_COPY_FILES += \
    device/google/barbet/nfc/libnfc-hal-st-G4S1M.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st-G4S1M.conf

# Bluetooth Tx power caps for barbet
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/bluetooth_power_limits_barbet_ROW.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_barbet_us.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_US.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_barbet_eu.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_EU.csv \
    $(LOCAL_PATH)/bluetooth_power_limits_barbet_jp.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits_JP.csv

# Keyboard bottom padding in dp for portrait mode
PRODUCT_PRODUCT_PROPERTIES += ro.com.google.ime.kb_pad_port_b=14.4

# SKU specific RROs
PRODUCT_PACKAGES += \
    SettingsOverlayG025H \
    SettingsOverlayG4S1M \
    SettingsOverlayG1F8F

# Set support hide display cutout feature
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_hide_display_cutout=true

PRODUCT_PACKAGES += \
    NoCutoutOverlay \
    AvoidAppsInCutoutOverlay

PRODUCT_COPY_FILES += \
    device/google/barbet/default-permissions.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions.xml

# (b/183612348): Enable skia reduceOpsTaskSplitting
PRODUCT_PROPERTY_OVERRIDES += \
    renderthread.skia.reduceopstasksplitting=true
