#!/system/bin/sh

error() { log -t "touchdriver" "error: $1"; }
abort() { log -t "touchdriver" "abort: $1"; exit 1; }

fastboot=$(cat /proc/cmdline)

if [[ $fastboot == *"twrpfastboot=1"* ]]
then
    log -t "touchdriver" "loading ramdisk touchscreen drivers"
    insmod /vendor/lib/modules/1.1/ftm5.ko-redfin || error "failed to load ramdisk ftm5"
    insmod /vendor/lib/modules/1.1/sec_touch.ko-redfin || error "failed to load ramdisk sec_touch"
    log -t "touchdriver" "loaded ramdisk touchscreen drivers"
else
    log -t "touchdriver" "loading vendor touchscreen and vibrator drivers"
    twrp mount vendor || abort "twrp failed to mount vendor"
    modprobe -d /vendor/lib/modules drv2624.ko || error "failed to load vendor vibrator"
    modprobe -d /vendor/lib/modules ftm5.ko || error "failed to load vendor ftm5"
    modprobe -d /vendor/lib/modules sec_touch.ko || error "failed to load vendor sec_touch"
    twrp unmount vendor || error "twrp failed to unmount vendor"
    log -t "touchdriver" "loaded vendor touchscreen and vibrator drivers"
fi

echo transient > /sys/class/leds/vibrator/trigger || abort "failed to created vibrator's one time activation trigger properties"
log -t "touchdriver" "created vibrator's one time activation trigger properties"
