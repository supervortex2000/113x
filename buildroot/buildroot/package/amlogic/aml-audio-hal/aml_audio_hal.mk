#############################################################
#
# aml_audio_service
#
#############################################################
AML_AUDIO_HAL_VERSION:=1.0
AML_AUDIO_HAL_SITE=$(TOPDIR)/../multimedia/aml_audio_hal
AML_AUDIO_HAL_SITE_METHOD=local
AML_AUDIO_HAL_DEPENDENCIES=android-tools aml-amaudioutils liblog tinyalsa expat avsync-lib mediahal-sdk
ifeq ($(BR2_PACKAGE_AML_AUDIO_HAL_EQ_DRC),y)
AML_AUDIO_HAL_CONF_OPTS += -DUSE_EQ_DRC=ON
endif
ifeq ($(BR2_PACKAGE_AML_AUDIO_HAL_DVB),y)
AML_AUDIO_HAL_CONF_OPTS += -DUSE_DTV=ON
AML_AUDIO_HAL_DEPENDENCIES += libplayer aml-dvb
else
AML_AUDIO_HAL_CONF_OPTS += -DUSE_DTV=OFF
endif
ifeq ($(BR2_PACKAGE_AML_AUDIO_HAL_MSYNC),y)
AML_AUDIO_HAL_CONF_OPTS += -DUSE_MSYNC=ON
endif
AML_AUDIO_HAL_INSTALL_STAGING = NO
AML_AUDIO_HAL_INSTALL_TARGET = YES

export AML_AUDIO_HAL_BUILD_DIR = $(BUILD_DIR)
export AML_AUDIO_HAL_STAGING_DIR = $(STAGING_DIR)
export AML_AUDIO_HAL_TARGET_DIR = $(TARGET_DIR)
export AML_AUDIO_HAL_BR2_ARCH = $(BR2_ARCH)

$(eval $(cmake-package))
