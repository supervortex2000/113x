#!/bin/sh

USB_STATE=`cat /sys/class/android_usb/android0/state`
echo $USB_STATE

if [ $USB_STATE != "CONFIGURE" ]; then
    echo fe340000.crgudc2 > /sys/kernel/config/usb_gadget/amlogic/UDC
fi
