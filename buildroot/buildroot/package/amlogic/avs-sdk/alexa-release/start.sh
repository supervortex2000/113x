#!/bin/sh
export LD_LIBRARY_PATH=/usr/lib:/usr/share/alexa-release/output-arm/lib:/usr/share/alexa-release/output-arm/lib/gstreamer-1.0:/usr/share/alexa-release/avs-out/lib:/usr/share/alexa-release/usr/lib

export GST_PLUGIN_PATH=/usr/share/alexa-release/output-arm/lib:/usr/share/alexa-release/output-arm/lib/gstreamer-1.0

export GST_PLUGIN_SCANNER=/usr/share/alexa-release/output-arm/libexec/gstreamer-1.0/gst-plugin-scanner

cd /usr/share/alexa-release

#wifi_connect_ap_test iPhone liuyang999
#wifi_connect_ap_test 2.4 12345678
#wifi_connect_ap_test Xiaomi_Test  12345678

 #date -s 2017-1-1
./avs-out/bin/SampleApp AlexaClientSDKConfig.json  /usr/share/alexa-release/avs-out/models/thfft_alexa_a_enus_v3_1mb_search_8.snsr DEBUG9
