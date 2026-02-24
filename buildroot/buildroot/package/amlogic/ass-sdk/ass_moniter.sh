#!/bin/sh

CONFIG=/etc/AlexaClientSDKConfig.json
DISPLAY_CONFIG=/etc/GuiConfigSample_SmartScreenLargeLandscape.json
PROCESS=/usr/bin/SampleApp

if cat /proc/device-tree/compatible | grep "amlogic,meson8b"; then
    SUPPORT_ASS=1
fi

start_ass() {
    local channel=0
    if [ -f $CONFIG ];then
        mkdir -p /data/share/avs/
        mkdir -p /data/share/ass/
        cd /usr/bin/
        if [ -n "$SUPPORT_ASS" ]
        then
            echo "get amlogic A213y board"
            /usr/bin/switch_mics_num.sh 2
            let channel=4
        else
            echo "get amlogic A113 board"
            /usr/bin/switch_mics_num.sh 6
            let channel=16
        fi
        ./SampleApp -C $CONFIG -C $DISPLAY_CONFIG -L NONE -c $channel &
        cd -
    else
        echo "ass start fail: not found config file $CONFIG!!!"
    fi
}

start_speaker_process () {
    /usr/bin/speaker_process &
}

if [ -z "$SUPPORT_ASS" ]; then
    modprobe snd-aloop

    amixer_ctr=`amixer controls | grep "Loopback Enable"` > /dev/null
    loop_id=${amixer_ctr%%,*}
    amixer cset $loop_id 1

    amixer_ctr=`amixer controls | grep "datain_datalb_total"` > /dev/null
    datalb_id=${amixer_ctr%%,*}
    amixer cset $datalb_id 16
fi

if [ -r /etc/last_date ]; then
    saved_date=$(cat /etc/last_date)
    date -s "$saved_date" > /dev/null
    if [ $? = 0 ]; then
        echo "Set with last saved date $saved_date OK"
    fi
fi

while true ; do

    ps -fe|grep SampleApp |grep -v grep 1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "start ass....."
        start_ass
    fi
    if [ -f /etc/init.d/ass_mdns.sh ]; then
        # start avs mdns service for avs setup
        /etc/init.d/ass_mdns.sh
    fi
    sleep 10
done
