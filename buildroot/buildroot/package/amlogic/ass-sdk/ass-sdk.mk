#####################################################################################
#
#ass-sdk (alexa smart screen sdk)
#
#####################################################################################
#ASS_VERSION:=2.8.0
ASS_SDK_SITE = $(TOPDIR)/../vendor/amlogic/ass-sdk
ASS_SDK_SITE_METHOD = local
ASS_SDK_LICENSE = Apache License 2.0
ASS_SDK_LICENSE = LICENSE

ASS_SDK_KWD_PATH = avs-sdk/shared/KWD/acsdkKWDImplementations

ifeq ($(BR2_PACKAGE_AML_SOC_BOARD_NAME),"AU401")
ASS_SDK_DEPENDENCIES = websocketpp \
                        nodejs \
                        apl-core-library \
                        apl-client-library \
                        avs-sdk \
                        boost
else
ASS_SDK_DEPENDENCIES = websocketpp \
                        nodejs
endif


ASS_SDK_CONF_OPTS = \
                     -DCMAKE_PREFIX_PATH=${STAGING_DIR}/usr
#                    -DBUILD_OUT_OF_TREE=ON \
#                    -DGSTREAMER_MEDIA_PLAYER=ON \
#                    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
#                    -DBUILD_TESTING=ON \
#                    -DTOTEM_PLPARSER=ON


# port audio, need extenal package
ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
ASS_SDK_DEPENDENCIES += portaudio
ASS_SDK_CONF_OPTS += -DPORTAUDIO:BOOL=ON
ASS_SDK_CONF_OPTS += -DPORTAUDIO_LIB_PATH=${BUILD_DIR}/portaudio-v190600_20161030/lib/.libs/libportaudio.so
ASS_SDK_CONF_OPTS += -DPORTAUDIO_INCLUDE_DIR=$(BUILD_DIR)/portaudio-v190600_20161030/include
endif

# APL core liabrary
ASS_SDK_CONF_OPTS += -DAPL_CORE:BOOL=ON
ASS_SDK_CONF_OPTS += -DAPLCORE_INCLUDE_DIR=${BUILD_DIR}/apl-core-library/aplcore/include
ASS_SDK_CONF_OPTS += -DAPLCORE_BUILD_INCLUDE_DIR=${BUILD_DIR}/apl-core-library/aplcore/include
ASS_SDK_CONF_OPTS += -DAPLCORE_LIB_DIR=${BUILD_DIR}/apl-core-library/aplcore

# APL client library
ifeq ($(BR2_PACKAGE_AML_SOC_BOARD_NAME),"AU401")
ASS_SDK_CONF_OPTS += -DAPL_CLIENT_INSTALL_PATH=$(TARGET_DIR)/usr \
                     -DAPL_CLIENT_JS_PATH=${BUILD_DIR}/apl-client-library/apl-client-js \
                     -DAPLCLIENT_INCLUDE_DIRS=${BUILD_DIR}/apl-client-library/APLClient/include \
                     -DAPLCLIENT_LDFLAGS=libAPLClient.so
endif


# rapid json
ASS_SDK_CONF_OPTS += -DAPLCORE_RAPIDJSON_INCLUDE_DIR=${BUILD_DIR}/apl-core-library/rapidjson-prefix/src/rapidjson/include

# yoga
ASS_SDK_CONF_OPTS += -DYOGA_INCLUDE_DIR=${BUILD_DIR}/apl-core-library/yoga-prefix/src/yoga
ASS_SDK_CONF_OPTS += -DYOGA_LIB_DIR=${BUILD_DIR}/apl-core-library/lib

ASS_SDK_CONF_OPTS += -DDISABLE_WEBSOCKET_SSL=ON \
                    -DGSTREAMER_MEDIA_PLAYER=ON \
                    -DWEBSOCKETPP_INCLUDE_DIR=${BUILD_DIR}websocketpp-0.8.1 \
                    -DASIO_INCLUDE_DIR=${BUILD_DIR}/boost-1.77.0

#add by liuyi
ifeq ($(BR2_PACKAGE_SENSORY),y)
ASS_SDK_CONF_OPTS += -DSENSORY_KEY_WORD_DETECTOR=ON
endif

ifeq ($(BR2_PACKAGE_KITT_AI),y)
ASS_SDK_CONF_OPTS += -DKITTAI_KEY_WORD_DETECTOR=ON
endif

ifeq ($(BR2_AVS_DSPC_AEC),y)
ASS_SDK_CONF_OPTS += -DEXT_WWE_DSP_KEY_WORD_DETECTOR=ON
ASS_SDK_CONF_OPTS += -DDSP_KEY_WORD_DETECTOR_LIB_PATH=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/DSP/lib/
ASS_SDK_CONF_OPTS += -DDSP_KEY_WORD_DETECTOR_INCLUDE_DIR=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/DSP/include/
endif

ifeq ($(BR2_AVS_AMAZON_WWE),y)
ASS_SDK_CONF_OPTS += -DAMAZON_KEY_WORD_DETECTOR=ON
ASS_SDK_CONF_OPTS += -DAMAZON_KEY_WORD_DETECTOR_LIB_PATH=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/Amazon/lib/libpryon_lite.so.1.13
ASS_SDK_CONF_OPTS += -DAMAZON_KEY_WORD_DETECTOR_INCLUDE_DIR=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/Amazon/include
endif

ifeq ($(BR2_AVS_RDSPC),y)
ASS_SDK_CONF_OPTS += -DRDSP_KEY_WORD_DETECTOR=ON
ASS_SDK_CONF_OPTS += -DRDSP_KEY_WORD_DETECTOR_LIB_PATH=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/RDSP/lib/librdsp.so
ASS_SDK_CONF_OPTS += -DRDSP_KEY_WORD_DETECTOR_INCLUDE_DIR=$(BUILD_DIR)/$(ASS_SDK_KWD_PATH)/RDSP/include
endif

ifeq ($(BR2_AVS_CLIENT_API),y)
ASS_SDK_CONF_OPTS += -DAVS_CLIENT_API=ON
ASS_SDK_CONF_OPTS += -DSERVER_INCLUDE_DIR=$(BUILD_DIR)/avs-sdk/Server
endif

# install ASS && AVS SDK
define ASS_SDK_POST_INSTALL_TARGET
    cp $(ASS_SDK_PKGDIR)/S49ass $(TARGET_DIR)/etc/init.d
    cp $(ASS_SDK_PKGDIR)/ass_moniter.sh $(TARGET_DIR)/etc/init.d
    mkdir -p $(TARGET_DIR)/var/www/cgi-bin
    cp $(ASS_SDK_PKGDIR)/cgi-bin/* $(TARGET_DIR)/var/www/cgi-bin/
    if [ "$(BR2_PACKAGE_AVAHI)" == "n" ] || [ -z "$(BR2_PACKAGE_AVAHI)" ]; then \
        $(INSTALL) -D -m 755 $(ASS_SDK_PKGDIR)/ass_mdns.sh \
        $(TARGET_DIR)/etc/init.d; \
    fi
    mkdir -p $(TARGET_DIR)/var/www/ass
    mkdir -p $(TARGET_DIR)/var/www/ass/js
    cp $(BUILD_DIR)/ass-sdk/modules/GUI/*.js $(TARGET_DIR)/var/www/ass/
    cp $(BUILD_DIR)/ass-sdk/modules/GUI/*.html $(TARGET_DIR)/var/www/ass/
    cp $(BUILD_DIR)/ass-sdk/modules/GUI/*.png $(TARGET_DIR)/var/www/ass/
    cp $(BUILD_DIR)/ass-sdk/modules/GUI/js/*.js $(TARGET_DIR)/var/www/ass/js/
    cp $(BUILD_DIR)/ass-sdk/modules/GUI/config/guiConfigSamples/GuiConfigSample_SmartScreenLargeLandscape.json $(TARGET_DIR)/etc/
endef

ASS_SDK_POST_INSTALL_TARGET_HOOKS += ASS_SDK_POST_INSTALL_TARGET

$(eval $(cmake-package))
