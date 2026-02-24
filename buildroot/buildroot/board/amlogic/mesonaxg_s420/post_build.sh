#!/bin/sh

# Changed the WiFi AND BT for MATTER
if [ -f $1/usr/bin/chip-shell ] ; then
	if [ -f $1/etc/bluetooth/main.conf ] ; then
		sed -i 's/Device=aml/Device=bcm/g' $1/etc/bluetooth/main.conf
	fi

	mv $1/etc/init.d/Matter-WiFi $1/etc/init.d/S39wifi
fi

if [ -f $1/etc/alsa_bsa.conf ]; then
	sed -i 's/^device=.*/device=dmixer_auto/' "$1/etc/alsa_bsa.conf"
fi
