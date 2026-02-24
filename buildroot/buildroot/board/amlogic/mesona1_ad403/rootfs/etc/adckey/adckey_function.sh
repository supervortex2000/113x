#!/bin/sh
uac_sys_ctr_file=/sys/devices/platform/audiobridge/bridge1/bridge_capture_volume_ctr
dsp_sys_ctr_file=/sys/devices/platform/audiobridge/bridge0/bridge_capture_volume_ctr
usb_conn_state_file=/sys/devices/virtual/android_usb/android0/state
bt_call_state_file=/tmp/hfp_state
power_resume=/tmp/power_resume
spiled_blue=/usr/sbin/spi_led
hfp_ctl_bin=/usr/bin/hfp_ctl_cmd
HFP_STATE_DISCONNECT=0
HFP_STATE_CONNECT=1
HFP_STATE_CALL_IN=2
HFP_STATE_CALL_OUT=3
HFP_STATE_CALL_OUT_RINGING=4
HFP_STATE_CALL_IN_OUT_OVER=5
HFP_STATE_CALL_START=6
HFP_STATE_CALL_ENDED=7

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

shutdown_process()
{
    /usr/bin/killall klogd
    /usr/bin/killall syslogd
    /etc/init.d/rcK
    /bin/umount -a -r
    /sbin/swapoff -a
    poweroff
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
        bt_state=$(cat $bt_call_state_file)
        if [ $bt_state = "$HFP_STATE_CALL_IN" ] ||
            [ $bt_state = "$HFP_STATE_CALL_OUT" ] ||
            [ $bt_state = "$HFP_STATE_CALL_OUT_RINGING" ] ||
            [ $bt_state = "$HFP_STATE_CALL_IN_OUT_OVER" ] ||
            [ $bt_state = "$HFP_STATE_CALL_START" ]; then
            echo "handfree is calling, no process"
            return 0;
        fi
    fi

    # idle into poweroff
    shutdown_process
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

speaker_vol_process()
{
    echo $1 > $uac_sys_ctr_file

    # check call state
    if [ -f $bt_call_state_file ];then
        bt_state=$(cat $bt_call_state_file)
        if [ $bt_state = "$HFP_STATE_CALL_START" ]; then
            if [ $1 == "1" ]; then
                $hfp_ctl_bin -vol_spk_down
            else
                $hfp_ctl_bin -vol_spk_up
            fi
        fi
    fi
}

mic_vol_process()
{
    echo $1 > $uac_sys_ctr_file

    # check call state
    if [ -f $bt_call_state_file ];then
        bt_state=$(cat $bt_call_state_file)
        if [ $bt_state = "$HFP_STATE_CALL_START" ]; then
            if [ $1 == "1" ]; then
                $hfp_ctl_bin -vol_mic_down
            else
                $hfp_ctl_bin -vol_mic_up
            fi
        fi
    fi
}

play_process()
{
    # check call state
    if [ -f $bt_call_state_file ];then
        bt_state=$(cat $bt_call_state_file)
        if [ $bt_state = "$HFP_STATE_DISCONNECT" ] ||
            [ $bt_state = "$HFP_STATE_CONNECT" ] ||
            [ $bt_state = "$HFP_STATE_CALL_ENDED" ]; then
            echo 8 > $uac_sys_ctr_file
        elif [ $bt_state = "$HFP_STATE_CALL_IN" ]; then
            echo "call in, to answer"
            $hfp_ctl_bin -answer_call
        else
            echo "reject call"
            $hfp_ctl_bin -reject_call
        fi
    else
        echo 8 > $uac_sys_ctr_file
    fi
}

longpress_play_process()
{
    # check call state
    if [ -f $bt_call_state_file ];then
        bt_state=$(cat $bt_call_state_file)
        if [ $bt_state = "$HFP_STATE_DISCONNECT" ] ||
            [ $bt_state = "$HFP_STATE_CONNECT" ] ||
            [ $bt_state = "$HFP_STATE_CALL_ENDED" ]; then
            echo 8 > $uac_sys_ctr_file
        else
            echo "reject call"
            $hfp_ctl_bin -reject_call
        fi
    else
        echo 8 > $uac_sys_ctr_file
    fi
}

if [[ -e $uac_sys_status_file ]] && [[ -e $dsp_sys_ctr_file ]];then
	case $1 in
		"VolumeUp")   speaker_vol_process 2 ;;
		"curlongpressVolumeUp")   mic_vol_process 2 ;;
		"VolumeDown") speaker_vol_process 1 ;;
		"curlongpressVolumeDown") mic_vol_process 1 ;;
		"Mute")  mic_mute_process ;;
		"Play")  play_process ;;
		"power")   power_down_check ;;
		"longpressPlay") longpress_play_process ;;
		"longpresspower")  shutdown_process ;;
		"longpressMute")   bluez_tool.sh start;;
		*) echo "no function to add this case: $1" ;;
	esac
fi

exit
