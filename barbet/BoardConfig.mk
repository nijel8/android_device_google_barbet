#
# Copyright (C) 2018 The Android Open-Source Project
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

TARGET_BOOTLOADER_BOARD_NAME := barbet
TARGET_SCREEN_DENSITY := 420
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
USES_DEVICE_GOOGLE_BARBET := true

DEVICE_PATH := device/$(BOARD_VENDOR)/$(PRODUCT_RELEASE_NAME)

# Copy TWRP ramdisk files automatically
TARGET_RECOVERY_DEVICE_DIRS := $(DEVICE_PATH)

# Qcom Decryption
BOARD_USES_QCOM_FBE_DECRYPTION := true

TARGET_PREBUILT_KERNEL := device/google/barbet/recovery/kernel/Image.lz4-redfin
BOARD_KERNEL_IMAGE_NAME   := Image.lz4-redfin

BOARD_VENDOR_SEPOLICY_DIRS += device/google/barbet/sepolicy

# Recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.vibrator-service.barbet \
    libandroidicu \
    libion

TARGET_RECOVERY_TWRP_LIB := \
    librecovery_twrp_barbet \
    libnos_citadel_for_recovery \
    libnos_for_recovery \
    liblog \
    libbootloader_message \
    libfstab \
    libext4_utils

RECOVERY_BINARY_SOURCE_FILES += \
    $(TARGET_OUT_VENDOR_EXECUTABLES)/hw/android.hardware.vibrator-service.barbet
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so

include device/google/redbull/BoardConfig-common.mk

# Allow LZ4 compression
BOARD_RAMDISK_USE_LZ4 := true

# Testing related defines
#BOARD_PERFSETUP_SCRIPT := platform_testing/scripts/perf-setup/b9-setup.sh

-include vendor/google_devices/$(TARGET_BOOTLOADER_BOARD_NAME)/proprietary/BoardConfigVendor.mk

-include device/google/barbet/soong/pixel_soong_config.mk
