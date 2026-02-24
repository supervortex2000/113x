#!/bin/sh

cp -av profile /etc/
#cp rc.local /etc/
rm -rf /usr/lib/libssl.so*
rm -rf /usr/lib/libcrypto.so*

source /etc/profile


cp ${HOME_PATH}/dnsmasq.conf /etc/

chmod 777 ${HOME_PATH}/start_ap.sh
chmod 777 ${HOME_PATH}/stop_ap.sh
chmod 777 ${HOME_PATH}/start_host.sh
chmod 777 ${HOME_PATH}/kill_avs.sh
chmod 777 ${HOME_PATH}/run.sh
chmod 777 ${HOME_PATH}/cron.sh
mkdir /var/lib/misc
touch /var/lib/misc/dnsmasq.leases

sync
