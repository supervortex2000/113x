#!/bin/sh

configure_file="/etc/bluetooth/main.conf"
configure_bkp_file="/etc/bluetooth/main_bkp.conf"


A2DP_SINK_SERVICE()
{
	echo "|--bluez a2dp-sink/hfp-hf service--|"
	hciconfig hci0 up

	grep -Insr "debug=1" $configure_file > /dev/null
	if [ $? -eq 0 ]; then

	echo "|--bluez service in debug mode--|"
		/usr/libexec/bluetooth/bluetoothd -n -d 2> /etc/bluetooth/bluetoothd.log &
		bluealsa -p a2dp-sink -p hfp-hf 2> /etc/bluetooth/bluealsa.log &
		usleep 200000
		bluealsa-aplay --profile-a2dp 00:00:00:00:00:00 -d plug:softvol 2> /etc/bluetooth/bluetoothd.log &
	else
		/usr/libexec/bluetooth/bluetoothd -n &
		bluealsa -p a2dp-sink -p hfp-hf 2> /dev/null &
		usleep 200000
		bluealsa-aplay --profile-a2dp 00:00:00:00:00:00 -d plug:softvol 2> /dev/null &
	fi
	default_agent > /dev/null &
	hfp_ctl &

	hciconfig hci0 class 0x240408

        for i in `seq 1 10`
        do
            sleep 2
            hciconfig hci0 piscan
            echo $(hciconfig) | grep PSCAN
            if [ $? -eq 0 ]
            then
                echo "hci0 already open scan"
                break;
            else
                if [ $i -eq 10 ]
                then
                    echo "hci0 open scan fail!"
                fi
            fi
        done
	hciconfig hci0 inqparms 18:1024
	hciconfig hci0 pageparms 18:1024
}

A2DP_SOURCE_SERVICE()
{
	echo "|--bluez a2dp-source service--|"
	hciconfig hci0 up

	grep -Insr "debug=1" $configure_file > /dev/null
	if [ $? -eq 0 ]; then

	echo "|--bluez service in debug mode--|"
		/usr/libexec/bluetooth/bluetoothd -n -d 2> /etc/bluetooth/bluetoothd.log &
		sleep 1
		bluealsa -p a2dp-source 2> /etc/bluetooth/bluealsa.log &
	else
		/usr/libexec/bluetooth/bluetoothd -n &
		sleep 1
		bluealsa -p a2dp-source 2> /dev/null &
	fi
	default_agent > /dev/null &
}


service_down()
{
	echo "|--stop bluez-alsa service--|"
	killall hfp_ctl
	killall default_agent
	killall bluealsa-aplay
	killall bluealsa
	killall bluetoothd
}

service_up()
{
	if [ $mode = "source" ];then
		A2DP_SOURCE_SERVICE
	else
		A2DP_SINK_SERVICE
	fi
}

if [ ! -s $configure_file ];then
	cp $configure_bkp_file $configure_file -f
fi

if [ $2 ];then
	mode=$2
else
	mode="sink"
fi


case "$1" in
	start)
		service_up &
		;;
	restart)
		;;
	stop)
		service_down
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
esac

exit $?

