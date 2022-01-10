#!/system/bin/sh

boot_reason=$(getprop ro.boot.bootreason | cut -d "," -F2)

log -t "touchdriver" "boot_reason: $boot_reason"

if [[ $boot_reason == "bootloader" ]]
then
    log -t "touchdriver" "loading ramdisk touchdriver"
    insmod /vendor/lib/modules/1.1/ftm5.ko-redfin
    insmod /vendor/lib/modules/1.1/sec_touch.ko-redfin
    log -t "touchdriver" "loaded ramdisk touchdriver"
else
    log -t "touchdriver" "loading vendor touchdriver"
    twrp mount vendor
    modprobe -d /vendor/lib/modules ftm5.ko
    modprobe -d /vendor/lib/modules sec_touch
    twrp unmount vendor
    log -t "touchdriver" "loaded vendor touchdriver"
fi
