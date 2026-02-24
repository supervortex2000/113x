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
		echo "#user.*                    /var/log/wpeframework.log" >> $1/etc/rsyslog.conf
		echo "#user.*                    /dev/ttyS0" >> $1/etc/rsyslog.conf
		sed -i '/\/var\/log\/messages/ s/^/#/g' $1/etc/rsyslog.conf
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

# for Youtube cerification Test
if [ ! -f $1/etc/WPEFramework/plugins/YtCert.json ] ; then
	cp $1/etc/WPEFramework/plugins/Cobalt.json $1/etc/WPEFramework/plugins/YtCert.json
	sed -i 's/www.youtube.com\/tv/ytlr-cert.appspot.com\/2021\/main.html/g' $1/etc/WPEFramework/plugins/YtCert.json
	sed -i 's/wst-cobalt/wst-YtCert/g' $1/etc/WPEFramework/plugins/YtCert.json
fi

# for Youtube cerification Test 12H Endurance
if [ ! -f $1/etc/WPEFramework/plugins/StressTest.json ] ; then
	cp $1/etc/WPEFramework/plugins/Cobalt.json $1/etc/WPEFramework/plugins/StressTest.json
	sed -i 's/tv/&?automationRoutine=watchEnduranceRoutine\&list=PLT2JIu9jdshr-q6fs7BCqAygvTHwnZUIt\&use_toa=1/g' $1/etc/WPEFramework/plugins/StressTest.json
	sed -i 's/wst-cobalt/wst-StressTest/g' $1/etc/WPEFramework/plugins/StressTest.json
fi

if [ -f $1/etc/init.d/S80WPEFramework ] ; then
	textexist=$(cat $1/etc/init.d/S80WPEFramework | grep "default_tvp_pool_size_0")
	echo "textexist = $textexist"
	if [ -z "$textexist" ] ; then
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a #echo codec_mm.default_tvp_pool_size_2=16777216 > /sys/class/codec_mm/config' $1/etc/init.d/S80WPEFramework
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a echo codec_mm.default_tvp_pool_size_1=25165824 > /sys/class/codec_mm/config' $1/etc/init.d/S80WPEFramework
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a echo codec_mm.default_tvp_pool_size_0=46137344 > /sys/class/codec_mm/config' $1/etc/init.d/S80WPEFramework
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a \\n# Set tvp to 3 phase 44, 24, 16' $1/etc/init.d/S80WPEFramework
	fi
	textexist=$(cat $1/etc/init.d/S80WPEFramework | grep "bypass_vpp")
	if [ -z "$textexist" ] ; then
		sed -i '/echo 1 > \/sys\/module\/amvdec_ports\/parameters\/av1_need_prefix/a echo 1 > \/sys\/module\/amvdec_ports\/parameters\/bypass_vpp' $1/etc/init.d/S80WPEFramework
	fi
	textexist=$(cat $1/etc/init.d/S80WPEFramework | grep "WESTEROS_SINK_AMLOGIC_LM_MODE")
	echo "textexist = $textexist"
	if [ -z "$textexist" ] ; then
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a export WESTEROS_SINK_AMLOGIC_LM_MODE=1' $1/etc/init.d/S80WPEFramework
	fi
	textexist=$(cat $1/etc/init.d/S80WPEFramework | grep "RDKSHELL_KEYMAP_FILE")
	echo "textexist = $textexist"
	if [ -z "$textexist" ] ; then
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a export RDKSHELL_KEYMAP_FILE=/etc/amlremote_keymap.conf' $1/etc/init.d/S80WPEFramework
		sed -i '/export WESTEROS_GL_USE_UEVENT_HOTPLUG=1/a export ESSOS_NO_EVENT_LOOP_THROTTLE=1' $1/etc/init.d/S80WPEFramework
	fi
fi

# for none privacy mode  OCDM plugin
if [ ! -f $1/etc/WPEFramework/plugins/OCDM_NOP.json ] ; then
	cp $1/etc/WPEFramework/plugins/OCDM.json $1/etc/WPEFramework/plugins/OCDM_NOP.json
	sed -i '/\"root\":{/i\ \ \"privacymode\":\"n\",' $1/etc/WPEFramework/plugins/OCDM_NOP.json
	sed -i 's/"autostart":true,/"autostart":false,/g'  $1/etc/WPEFramework/plugins/OCDM_NOP.json
fi
