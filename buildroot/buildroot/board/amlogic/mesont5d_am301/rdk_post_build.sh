#!/bin/sh
# $(TARGET_DIR) is the first parameter
# This script file to change rsyslogd.conf

set -x
TARGET_DIR=$1
echo "Run post build script to target dir $TARGET_DIR"

#TV no need set_display_mode.sh
if [ -f $TARGET_DIR/etc/set_display_mode.sh ]; then
    rm -fr $TARGET_DIR/etc/set_display_mode.sh
fi

#TV no need S50display
if [ -f $TARGET_DIR/etc/init.d/S50display ]; then
    rm -fr $TARGET_DIR/etc/init.d/S50display
fi

# Remove some no useful files
rm -frv $1/etc/init.d/S44bluetooth


# current stage it's just for wpeframework debug log
# wpeframework can output debug log to /var/log/wpeframework.log

# delete the syslogd related line in /etc/inittab
# syslog will be initialized by /etc/init.d/S01rsyslog
sed -i '/syslogd/ s/^/#/g' $1/etc/inittab
sed -i '/klogd/ s/^/#/g' $1/etc/inittab
#sed -i '/klogd/ s/^/#/g' $1/etc/inittab
rm -f $1/etc/init.d/S01syslogd
rm -f $1/etc/init.d/S02klogd


# Following is add default log to wpeframework.log
#echo "Start to change /etc/rsyslog.conf to enable wpeframework.log"
if [ -f $1/etc/rsyslog.conf ] ; then
# wpeframework uses syslog LOG_USER
# we will set it's log level with info
	textexist=$(cat $1/etc/rsyslog.conf | grep "wpeframework.log")
	echo "textexist = $textexist"
	if [ -z "$textexist" ] ; then
		echo "\n\n# rule for WPEFramework debug log" >> $1/etc/rsyslog.conf
		echo "user.*                    /var/log/wpeframework.log" >> $1/etc/rsyslog.conf
		echo "#user.*                    /dev/ttyS0" >> $1/etc/rsyslog.conf
	fi
fi


# Change Youtube cerification to 2021
# check whether launcher is exist
if [ -f $1/var/www/launcher/launcher.html ] ; then
	# check wether the target file has been changed before
	textexist=$(cat $1/var/www/launcher/launcher.html | grep "ytlr-cert.appspot.com/2021/main.html")
	echo "textexist = $textexist"
	if [ -z "$textexist" ] ; then
		sed -i 's/ytlr-cert.appspot.com/ytlr-cert.appspot.com\/2021\/main.html/g' $1/var/www/launcher/launcher.html
	fi
fi
