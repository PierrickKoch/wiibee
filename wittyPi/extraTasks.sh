#!/bin/bash
# file: extraTasks.sh
#
# This script will be launched in background after Witty Pi 2 get initialized.
# If you want to run your commands after boot, you can place them here.
#

#
# WiiBee mount and autorun USB
#
USB_DEV=/dev/sda1
USB_MNT=/mnt/bee1
logger "Check if USB disk is plugged in"
[ -e $USB_DEV ] && logger "mount $USB_DEV" || logger "missing $USB_DEV"
[ -d $USB_MNT ] || mkdir -p $USB_MNT
mount $USB_DEV $USB_MNT
SCRIPT="autorun.sh"
USB_DIR="${USB_MNT}/wiibee"
export WIIBEE_SHUTDOWN=1
export PATH="${USB_DIR}:${PATH}"
[ -x "${USB_DIR}/${SCRIPT}" ] && cd $USB_DIR && . $SCRIPT || exit 2
