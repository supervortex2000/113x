#!/bin/bash
#
# Copyright (c) 2021 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined
# in the file 'LICENSE' which is part of this source code package.
# Description: post build file
#
# $(TARGET_DIR) is the first parameter
# This script file to change rsyslogd.conf
# audioservice can output debug log to /var/log/audioservice.log

set -x
TARGET_DIR=$1
echo "Run post build script to target dir $TARGET_DIR"

if [ -f $TARGET_DIR/etc/alsa_bsa.conf ]; then
    echo "device=dmixer_auto" > $TARGET_DIR/etc/alsa_bsa.conf
fi

if [ -f $TARGET_DIR/etc/init.d/S44bluetooth ]; then
    sed -i 's/bt_name=\"amlogic\"/bt_name=\"amlogic-A1\"/g' $TARGET_DIR/etc/init.d/S44bluetooth
fi

if [ -f $TARGET_DIR/usr/bin/AMLogic_VUI_Solution_Model.awb ] && [ ! -L $TARGET_DIR/usr/bin/AMLogic_VUI_Solution_Model.awb ]; then
    pushd $TARGET_DIR/usr/bin/
    SRC_MODEL=""
    #AMLogic_VUI_Solution_Model.awb should be a link
    if cmp -s AMLogic_VUI_Solution_Model.awb AMLogic_VUI_Solution_Model_Gen2_2Mics.awb; then
        SRC_MODEL=AMLogic_VUI_Solution_Model_Gen2_2Mics.awb
    fi
    if cmp -s AMLogic_VUI_Solution_Model.awb AMLogic_VUI_Solution_Model_Gen2_4Mics.awb; then
        SRC_MODEL=AMLogic_VUI_Solution_Model_Gen2_4Mics.awb
    fi
    if cmp -s AMLogic_VUI_Solution_Model.awb AMLogic_VUI_Solution_Model_Gen2_6Mics.awb; then
        SRC_MODEL=AMLogic_VUI_Solution_Model_Gen2_6Mics.awb
    fi
    if [ -n "$SRC_MODEL" ]; then
        rm -f AMLogic_VUI_Solution_Model.awb
        ln -s $SRC_MODEL AMLogic_VUI_Solution_Model.awb
    fi
    popd
fi

if [ -d $TARGET_DIR/lib/debug ]; then
    rm -frv $TARGET_DIR/lib/debug
fi

#Our current libidn is v12, but soundai want to link with v11.
if [ ! -L $TARGET_DIR/usr/lib/libidn.so.11 ]; then
  pushd $TARGET_DIR/usr/lib/
  ln -s libidn.so.12 libidn.so.11
  popd
fi

if [ -f $TARGET_DIR/etc/init.d/S60input ]; then
	mv $TARGET_DIR/etc/init.d/S60input $TARGET_DIR/etc/init.d/S37input
fi

#Delete duplicate modules, kernel5.15's modules are in $TARGET_DIR/amlogic
#Note: Don't delete the ko of wifi and bt by mistake
if [ -d $TARGET_DIR/lib/modules/*/kernel/drivers ]; then
	rm $TARGET_DIR/lib/modules/*/kernel/drivers -rf
fi

if [ -d $TARGET_DIR/lib/modules/*/kernel/common_drivers ]; then
	rm $TARGET_DIR/lib/modules/*/kernel/common_drivers -rf
fi

#Turn off printing of module load scripts
if [ -f $TARGET_DIR/amlogic/modules/ramdisk/ramdisk_install.sh ]; then
    sed -i 's/set -x/set +x/' $TARGET_DIR/amlogic/modules/ramdisk/ramdisk_install.sh
fi

if [ -f $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh ]; then
    sed -i 's/set -x/set +x/' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    #Remove usb and wifi modules
    sed -i '/insmod amlogic-mmc.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod amlogic-wireless.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod amlogic-usb.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod dwc3.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod dwc3-of-simple.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod xhci-plat-hcd.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
    sed -i '/insmod dwc_otg.ko/d' $TARGET_DIR/amlogic/modules/vendor/vendor_install.sh
fi

#Adjust script startup order
if [ -f $TARGET_DIR/etc/init.d/S83dsd ]; then
    mv $TARGET_DIR/etc/init.d/S83dsd $TARGET_DIR/etc/init.d/S31dsd
fi

if [ -f $TARGET_DIR/etc/init.d/S90audioservice ]; then
    mv $TARGET_DIR/etc/init.d/S90audioservice $TARGET_DIR/etc/init.d/S32audioservice
fi

if [ -f $TARGET_DIR/etc/init.d/S91audioservice_monitor ]; then
    mv $TARGET_DIR/etc/init.d/S91audioservice_monitor $TARGET_DIR/etc/init.d/S33audioservice_monitor
fi