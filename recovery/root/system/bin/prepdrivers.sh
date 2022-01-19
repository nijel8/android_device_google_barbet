#!/system/bin/sh

error() { log -p e -t "prepdrivers" "error: $1"; }

fastboot=$(cat /proc/cmdline)

# modprobe seems unreliable if twrp is fastbooted,
# using insmod to load ramdisk kernel modules,
# otherwise twrp loads vendor kernel modules
if [[ $fastboot == *"twrpfastboot=1"* ]]; then
    insmod /drivers/ftm5.ko-redfin || error "failed to load ramdisk ftm5"
    insmod /drivers/sec_touch.ko-redfin || error "failed to load ramdisk sec_touch"
fi

# waiting for haptics kernel module to create nodes
while [ ! -e /sys/class/leds/vibrator/device ]; do sleep 0.5; done

log -t "prepdrivers" "touchscreen and haptics drivers ready"

echo transient > /sys/class/leds/vibrator/trigger \
    || error "failed to create vibrator's one time activation trigger properties"

# making sure vendor is unmounted or servicemanager fails to parse A12 manifest.xml
if [[ $fastboot != *"twrpfastboot=1"* ]]; then
    while mountpoint -q /vendor; do umount /vendor \
        || error "failed to unmount vendor"; sleep 0.5; done
fi

# init trigger for vibrator service
resetprop vibrator.haptics.ready 1

log -t "prepdrivers" "vibrator.barbet service ready to start..."
