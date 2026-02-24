#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin

count=0

while [ $count -le 4 ]
do
	wpa_cli -i wlan0 scan > /dev/null
	#wpa_cli -i wlan0 scan_result | cut -f 5- | sed /^$/d > /data/data_wifi_list
	wpa_cli -i wlan0 scan_result | sed /^$/d > /data/data_wifi_list
	sleep 0.1

	let count++
done

cat /data/data_wifi_list

