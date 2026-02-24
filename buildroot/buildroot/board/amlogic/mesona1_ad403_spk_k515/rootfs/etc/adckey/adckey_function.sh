#!/bin/sh
#
# Copyright (c) 2021 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined in the file 'LICENSE' which is part of this source code package.
# Description:  adc key file
#
usb_conn_state_file=/sys/devices/virtual/android_usb/android0/state
power_resume=/tmp/power_resume
spiled_blue=/usr/sbin/spi_led

power_state_change()
{
       if [ -f $power_resume ];then
               rm $power_resume
               $spiled_blue -D /dev/spidev1.0 -b 32 -s 3340000 -v -c 000000ff
               return 0;
       fi
       #######suspend#######
       touch $power_resume
       echo "mem" > /sys/power/state
       ######resume#########
}

power_down_check()
{
    # check usb connect state
    usb_state=$(cat $usb_conn_state_file)
    if [ $usb_state == "CONFIGURED" ]; then
        echo "usb connected, no process"
        return 0;
    fi

    # idle into poweroff
    poweroff
}

volumeUpAction()
{
    amixer_vol_ctrl=`amixer controls | grep "DAC Digital Playback Volume"` > /dev/null
    vol_ctrl_id=${amixer_vol_ctrl%%,*}
    local volumeMax=`amixer cget "$vol_ctrl_id" | grep "type=" |awk -F, '{print $5}' | awk -F= '{print $2}'`
    local volumeCurrent=`amixer cget "$vol_ctrl_id" | grep ": values=" |awk -F, '{print $2}'`
    if [ $volumeCurrent -le $volumeMax ];then
        let volumeCurrent+=1
        echo "$volumeCurrent"
        if [ $volumeCurrent -ge $volumeMax ];then
            volumeCurrent=$volumeMax
        fi
        amixer cset "$vol_ctrl_id" $volumeCurrent,$volumeCurrent
    fi
}

volumeDownAction()
{
    amixer_vol_ctrl=`amixer controls | grep "DAC Digital Playback Volume"` > /dev/null
    vol_ctrl_id=${amixer_vol_ctrl%%,*}
    local volumeMin=`amixer cget "$vol_ctrl_id" | grep "type=" |awk -F, '{print $4}' | awk -F= '{print $2}'`
    local volumeCurrent=`amixer cget "$vol_ctrl_id" | grep ": values=" |awk -F, '{print $2}'`
    if [ $volumeCurrent -ge $volumeMin ];then
        let volumeCurrent-=1
        if [ $volumeCurrent -lt $volumeMin ];then
            volumeCurrent=$volumeMin
        fi
        amixer cset "$vol_ctrl_id" $volumeCurrent,$volumeCurrent
    fi
}

case $1 in
	"VolumeUp") volumeUpAction ;;
	"curlongpressVolumeUp")  volumeUpAction ;;
	"VolumeDown") volumeDownAction ;;
	"curlongpressVolumeDown") volumeDownAction ;;
	"Mute")  echo "Please link Mute key with player" ;;
	"Play")  echo "Please link Play Key with Player" ;;
	"power")  power_down_check ;;
	"longpresspower")  poweroff ;;
	"longpressMute")   bluez_tool.sh start ble ;;
	*) echo "no function to add this case: $1" ;;
esac

exit
