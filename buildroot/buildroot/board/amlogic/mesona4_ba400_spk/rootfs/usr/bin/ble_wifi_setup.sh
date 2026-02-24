#!/bin/sh

bluez_ble_service() {
	killall btgatt-server
	/etc/init.d/S44bluetooth reset ble
}

bsa_ble_service() {
	local app1_id=$(ps | grep "aml_musicBox" | awk '{print $1}')
	kill -9 $app1_id
	local app2_id=$(ps | grep "aml_ble_wifi_setup" | awk '{print $1}')
	kill -9 $app2_id
	cd /etc/bsa/config
	aml_ble_wifi_setup &
	aml_musicBox ble_mode &
}

ble_wifi_setup() {
	echo "ble config for wifisetup"
	mkdir -p /etc/bluetooth/
	echo 0 > /etc/bluetooth/wifi_status
	hciconfig hci0 >/dev/null
	if [ $? -eq 0 ]; then
		bluez_ble_service
	else
		bsa_ble_service
	fi
}
ble_wifi_setup