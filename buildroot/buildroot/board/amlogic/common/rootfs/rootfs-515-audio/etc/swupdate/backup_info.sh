#!/bin/sh
#
# Copyright (c) 2021 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined in the file 'LICENSE' which is part of this source code package.
# Description: backup info file
#
SWUPDATE_PATH=/data/swupdate

rm -fr $SWUPDATE_PATH
mkdir -p $SWUPDATE_PATH

#Copy swupdate script
cp -a /etc/swupdate/* $SWUPDATE_PATH/

#Copy Wifi setting and drivers
mkdir -p $SWUPDATE_PATH/etc
cp -a /etc/wifi $SWUPDATE_PATH/etc/
cp -a /etc/wpa_supplicant.conf $SWUPDATE_PATH/etc/
cp -a /etc/dhcpcd.conf $SWUPDATE_PATH/etc/

#Copy Wifi module
#wifi_power 2 will print "inf=xxx0" if success
inf=`wifi_power 2 | awk -F = '{print $2}'`
if [ "${inf}" = "" ];then
	dir="/sys/bus/mmc/devices/sdio0:0001/sdio0:0001:1/"
else
	dir="/sys/bus/mmc/devices/${inf}:0001/${inf}:0001:1/"
	if [ ! -d ${dir} ];then
		dir="/sys/bus/mmc/devices/${inf}:0000/${inf}:0000:1/"
	fi
fi

wifi_vendor_id=`cat "${dir}/vendor"`
case "${wifi_vendor_id}" in
	0x02d0)
		wifi_vendor="broadcom"
		;;
	0x8888) # chipid of w1
		wifi_vendor="amlogic"
		;;
	0x024c)
		wifi_vendor="realtek"
		;;
	*)
		wifi_vendor=""
		;;
esac

for path in $(find /lib/modules/ -name $wifi_vendor)
do
	if [ -d $path/wifi ]; then
		mkdir -p $SWUPDATE_PATH/$path/wifi/
		cp $path/wifi/* $SWUPDATE_PATH/$path/wifi/ -rf
	fi
done
