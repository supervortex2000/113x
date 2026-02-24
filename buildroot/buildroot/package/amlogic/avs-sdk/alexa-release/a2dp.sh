#!/bin/sh


configure_file="/etc/bluetooth/main.conf"
configure_bkp_file="/etc/bluetooth/main_bkp.conf"
alsa_file="/etc/alsa_bt.conf"
spk=dmixer_auto

	echo "|--bluez a2dp-sink/hfp-hf service--|"
	hciconfig hci0 up

	grep -Insr "debug=1" $configure_file > /dev/null
	if [ $? -eq 0 ]; then

	echo "|--bluez service in debug mode--|"
		/usr/libexec/bluetooth/bluetoothd -n -d 2> /etc/bluetooth/bluetoothd.log &
		sleep 1
		bluealsa -p a2dp-sink -p hfp-hf 2> /etc/bluetooth/bluealsa.log &
		usleep 200000
		bluealsa-aplay --profile-a2dp 00:00:00:00:00:00 -d $spk 2> /etc/bluetooth/bluealsa-aplay.log &
	else
		/usr/libexec/bluetooth/bluetoothd -n &
		sleep 1
		bluealsa -p a2dp-sink -p hfp-hf 2> /dev/null &
		usleep 200000
		bluealsa-aplay --profile-a2dp 00:00:00:00:00:00 -d $spk 2> /dev/null &
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
