#!/bin/sh
#
# Copyright (c) 2021 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined in the file 'LICENSE' which is part of this source code package.
# Description:  adc key file
#
uac_sys_ctr_file=/sys/devices/platform/audiobridge/bridge1/bridge_capture_volume_ctr
dsp_sys_ctr_file=/sys/devices/platform/audiobridge/bridge0/bridge_capture_volume_ctr
usb_conn_state_file=/sys/devices/virtual/android_usb/android0/state
bt_call_state_file=/tmp/hfp_calling_flag
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
    # check call state
    if [ -f $bt_call_state_file ];then
        echo "handfree is calling, no process"
        return 0;
    fi

    # idle into poweroff
    poweroff
}

mic_mute_process()
{
	echo 4 > $dsp_sys_ctr_file

	mute_state=$(cat $dsp_sys_ctr_file | grep "MuteState:" | awk '{print $2}')
	if [ $mute_state == "1" ]; then
		#mute
		spi_led -D /dev/spidev1.0 -b 32 -s 3340000 -v -c 00ff0000 > /dev/null
	elif [ $mute_state == "0" ]; then
		#unmute
		spi_led -D /dev/spidev1.0 -b 32 -s 3340000 -v -c 000000ff > /dev/null
	else
		echo "invalid mute state"
	fi
}

if [[ -e $uac_sys_status_file ]] && [[ -e $dsp_sys_ctr_file ]];then
	case $1 in
		"VolumeUp")   echo 2 > $uac_sys_ctr_file ;;
		"curlongpressVolumeUp")   echo 2 > $uac_sys_ctr_file ;;
		"VolumeDown") echo 1 > $uac_sys_ctr_file ;;
		"curlongpressVolumeDown") echo 1 > $uac_sys_ctr_file ;;
		"Mute")  mic_mute_process ;;
		"Play")  echo 8 > $uac_sys_ctr_file ;;
		"power")   power_down_check ;;
		"longpresspower")  poweroff ;;
		"longpressMute")   bluez_tool.sh start;;
		*) echo "no function to add this case: $1" ;;
	esac
fi

exit
