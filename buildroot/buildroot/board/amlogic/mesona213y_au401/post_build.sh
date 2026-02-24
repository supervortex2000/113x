#!/bin/bash
# $(TARGET_DIR) is the first parameter
# This script file to change rsyslogd.conf
# audioservice can output debug log to /var/log/audioservice.log

set -x
TARGET_DIR=$1
BR_PATH=`readlink -f $(dirname $BASH_SOURCE)/../../../../`
BOARD_DIR="$(dirname $0)"

echo "Builroot Path: $BR_PATH"
echo "Run post build script to target dir $TARGET_DIR"

#A213Y No Need For S50display
if [ -f $TARGET_DIR/etc/init.d/S50display ]; then
    rm -fr $TARGET_DIR/etc/init.d/S50display
fi

#A213Y Wifi scripts needs to be changed
if [ -f $TARGET_DIR/etc/init.d/S42wifi ]; then
    sed -i 's/0001/0000/g' $TARGET_DIR/etc/init.d/S42wifi
    # Use 'reboot' command to reboot board will cause system crash, delete 2 lines below
    sed -i '/MULTI_WIFI station 0$/d' $TARGET_DIR/etc/init.d/S42wifi
    sed -i '/POWERCTL 0$/d' $TARGET_DIR/etc/init.d/S42wifi
fi

#A213Y use mini busybox
if [ -f $BOARD_DIR/initramfs/busybox.mini ]; then
    cp $BOARD_DIR/initramfs/busybox.mini $TARGET_DIR/bin
fi

#A213Y dnsmasq scripts needs to be changed
if [ -f $TARGET_DIR/etc/init.d/S80dnsmasq ]; then
    sed -i 's/0001/0000/g' $TARGET_DIR/etc/init.d/S80dnsmasq
    sed -i 's/0x02d0)/0x02d0|0x8888)/g' $TARGET_DIR/etc/init.d/S80dnsmasq
fi

#Reinstall qt examples and plugins (sync with yocto)
if [ -d $TARGET_DIR/usr/lib/qt ]; then
    mv $TARGET_DIR/usr/lib/qt/plugins $TARGET_DIR/usr/lib
    mv $TARGET_DIR/usr/lib/qt/examples $TARGET_DIR/usr/share
    rm -rf $TARGET_DIR/usr/lib/qt
fi
