#!/bin/bash
# $(TARGET_DIR) is the first parameter
# This script file to change rsyslogd.conf
# audioservice can output debug log to /var/log/audioservice.log

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

