################################################################################
#
# audioservice
#
################################################################################

AUDIOSERVICE_VERSION = 1.0.0
AUDIOSERVICE_SITE = $(TOPDIR)/../vendor/amlogic/audioservice
AUDIOSERVICE_SITE_METHOD = local
#AUDIOSERVICE_LICENSE = GPLv2+, GPLv2 (py-smbus)
#AUDIOSERVICE_LICENSE_FILES = COPYING
AUDIOSERVICE_INSTALL_STAGING = YES
AUDIOSERVICE_AUTORECONF = YES

AUDIOSERVICE_DEPENDENCIES = libglib2 dbus cjson aml-commonlib

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_HALAUDIO),y)
AUDIOSERVICE_CONF_OPTS += --enable-halaudio
AUDIOSERVICE_DEPENDENCIES += aml-halaudio
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_ASR),y)
AUDIOSERVICE_CONF_OPTS += --enable-asr
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_PULSEAUDIO),y)
AUDIOSERVICE_CONF_OPTS += --enable-pulseaudio
AUDIOSERVICE_DEPENDENCIES += pulseaudio
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_RESAMPLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-resample
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_FFMPEG),y)
AUDIOSERVICE_CONF_OPTS += --enable-ffmpeg
AUDIOSERVICE_DEPENDENCIES += ffmpeg-aml
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_PYTHON),y)
AUDIOSERVICE_CONF_OPTS += --enable-python
AUDIOSERVICE_DEPENDENCIES += python
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_M6350),y)
AUDIOSERVICE_CONF_OPTS += --enable-external_m6350
AUDIOSERVICE_CONF_OPTS += --enable-external_input
EXTERNAL_M6350_LIB = libasexternal_m6350.so
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_962E),y)
AUDIOSERVICE_CONF_OPTS += --enable-external_962e
AUDIOSERVICE_CONF_OPTS += --enable-external_input
EXTERNAL_962E_LIB = libasexternal_962e.so
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_M031),y)
AUDIOSERVICE_CONF_OPTS += --enable-external_m031
AUDIOSERVICE_CONF_OPTS += --enable-external_input
EXTERNAL_M031_LIB = libasexternal_m031.so
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_ADV7674),y)
AUDIOSERVICE_CONF_OPTS += --enable-external_adv7674
AUDIOSERVICE_CONF_OPTS += --enable-external_input
EXTERNAL_ADV7674_LIB = libasexternal_adv7674.so
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_STRESSTEST),y)
AUDIOSERVICE_CONF_OPTS += --enable-stresstest
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_AB311_SBR),y)
AUDIOSERVICE_DEPENDENCIES += aml_halHdmicec
endif

ifeq ($(BR2_PACKAGE_AML_SOC_CHIP_NAME), "A113")
AUDIOSERVICE_CONF_OPTS += --enable-chip_a113
endif

ifeq ($(BR2_PACKAGE_AML_SOC_CHIP_NAME), "A113X2")
AUDIOSERVICE_CONF_OPTS += --enable-chip_a113x2
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_USBPLAYER),y)
AUDIOSERVICE_CONF_OPTS += --enable-usbplayer
AUDIOSERVICE_DEPENDENCIES += ffmpeg-aml aml-audio-player
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_AIRPLAY),y)
AUDIOSERVICE_CONF_OPTS += --enable-airplay
AUDIOSERVICE_DEPENDENCIES += airplay2
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_AMLUART),y)
AUDIOSERVICE_CONF_OPTS += --enable-amluart
endif

ifeq ($(BR2_AVS_CLIENT_API),y)
AUDIOSERVICE_CONF_OPTS += --enable-avs
AUDIOSERVICE_DEPENDENCIES += avs-sdk
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_CAST_LITE),y)
AUDIOSERVICE_CONF_OPTS += --enable-cast_lite
AUDIOSERVICE_DEPENDENCIES += cast-lite
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_LINE_IN_LOCAL),y)
AUDIOSERVICE_CONF_OPTS += --enable-line_in_local
endif

ifeq ($(BR2_PACKAGE_DOLBY_ATMOS_VERSION_1_7),y)
AUDIOSERVICE_CONF_OPTS += --enable-dolby_ver_1_7
endif

ifeq ($(BR2_PACKAGE_AML_LOG),y)
AUDIOSERVICE_CONF_OPTS += --enable-amllog
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_DISPLAY_LED_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-display_led
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_DISPLAY_LCD_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-display_lcd
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_DISPLAY_SPEAK_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-display_speak
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_INPUT_VAD_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-input_vad
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_KEY_BLE_CONFIG_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-key_ble_config
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_INPUT_BT_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-input_bt
endif

ifeq ($(BR2_PACKAGE_AUDIOSERVICE_HAL_HDMI_CEC_ENABLE),y)
AUDIOSERVICE_CONF_OPTS += --enable-hdmi_cec
endif

define AUDIOSERVICE_LIB_INSTALL_CMD

endef


# AUDIOSERVICe_CONF_OPTS = --prefix=$(TARGET_DIR)/usr
AUDIOSERVICE_EXTERNAL_INPUT_LIB = libasexternal_input.so

define AUDIOSERVICE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(AUDIOSERVICE_SITE)/script/S90audioservice \
		$(TARGET_DIR)/etc/init.d/S90audioservice
	$(INSTALL) -D -m 755 $(AUDIOSERVICE_SITE)/script/S91audioservice_monitor \
		$(TARGET_DIR)/etc/init.d/S91audioservice_monitor
	$(INSTALL) -D -m 644 \
		$(AUDIOSERVICE_SITE)/src/config/$(BR2_PACKAGE_AUDIOSERVICE_CONFIG_FILE) \
		$(TARGET_DIR)/etc/default_audioservice.conf

if [ -f $(AUDIOSERVICE_SITE)/homeapp/config/$(BR2_PACKAGE_AUDIOSERVICE_HOMEAPP_CONFIG_FILE) ]; then \
	$(INSTALL) -D -m 644 $(AUDIOSERVICE_SITE)/homeapp/config/$(BR2_PACKAGE_AUDIOSERVICE_HOMEAPP_CONFIG_FILE) \
	$(TARGET_DIR)/etc/default_homeapp.conf; \
fi
if [[ $(BR2_PACKAGE_AUDIOSERVICE_CONFIG_FILE) =~ "7_1_4" ]]; then \
	$(INSTALL) -D -m 644  $(AUDIOSERVICE_SITE)/src/config/br/dap_xml/dap_tuning_files_7_1_4.xml \
	$(TARGET_DIR)/etc/dap_tuning_files.xml; \
fi
if [[ $(BR2_PACKAGE_AUDIOSERVICE_CONFIG_FILE) =~ "5_1_2" ]]; then \
	$(INSTALL) -D -m 644  $(AUDIOSERVICE_SITE)/src/config/br/dap_xml/dap_tuning_files_5_1_2.xml \
	$(TARGET_DIR)/etc/dap_tuning_files.xml; \
fi
if [ "$(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_M6350)" == "y" ]; then \
	$(INSTALL) -d $(TARGET_DIR)/etc/mcu6350_bin/; \
	$(INSTALL) -D -m 644 \
		$(AUDIOSERVICE_SITE)/src/external/mcu6350_bin/* $(TARGET_DIR)/etc/mcu6350_bin/; \
	cd $(TARGET_DIR)/usr/lib; \
	ln -fs $(EXTERNAL_M6350_LIB) $(AUDIOSERVICE_EXTERNAL_INPUT_LIB); \
	cd -; \
fi
if [ "$(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_962E)" == "y" ]; then \
	cd $(TARGET_DIR)/usr/lib; \
	ln -fs $(EXTERNAL_962E_LIB) $(AUDIOSERVICE_EXTERNAL_INPUT_LIB); \
	cd -; \
fi
if [ "$(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_M031)" == "y" ]; then \
	$(INSTALL) -d $(TARGET_DIR)/etc/mcu031_bin/; \
	$(INSTALL) -D -m 644 \
		$(AUDIOSERVICE_SITE)/src/external/mcu031_bin/* $(TARGET_DIR)/etc/mcu031_bin/; \
	cd $(TARGET_DIR)/usr/lib; \
	ln -fs $(EXTERNAL_M031_LIB) $(AUDIOSERVICE_EXTERNAL_INPUT_LIB); \
	cd -; \
fi
if [ "$(BR2_PACKAGE_AUDIOSERVICE_EXTERNAL_ADV7674)" == "y" ]; then \
	cd $(TARGET_DIR)/usr/lib; \
	ln -fs $(EXTERNAL_ADV7674_LIB) $(AUDIOSERVICE_EXTERNAL_INPUT_LIB); \
	cd -; \
fi
endef

# Autoreconf requires an m4 directory to exist
define AUDIOSERVICE_PATCH_M4
	mkdir -p $(@D)/m4
endef

AUDIOSERVICE_POST_PATCH_HOOKS += AUDIOSERVICE_PATCH_M4



$(eval $(autotools-package))
