#!/bin/sh

export LD_LIBRARY_PATH=/usr/lib:/mnt/UDISK/alexa-release/usr/lib:/mnt/UDISK/alexa-release/avs-out/lib

#export GST_PLUGIN_PATH=/usr/share/alexa-release/output-arm/lib:/usr/share/alexa-release/output-arm/lib/gstreamer-1.0

#export GST_PLUGIN_SCANNER=/usr/share/alexa-release/output-arm/libexec/gstreamer-1.0/gst-plugin-scanner

cd /mnt/UDISK/alexa-release

./gdbserver 192.168.0.103:8888 ./avs-out/bin/SampleApp AlexaClientSDKConfig.json  /mnt/UDISK/alexa-release/avs-out/models/f8/ DEBUG9
#./avs-out/bin/SampleApp AlexaClientSDKConfig.json  /mnt/UDISK/alexa-release/avs-out/models/f8/ DEBUG9
