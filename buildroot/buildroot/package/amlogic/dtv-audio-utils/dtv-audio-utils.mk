#############################################################
#
# dtv-audio-utils
#
#############################################################
DTV_AUDIO_UTILS_VERSION:=1.0
DTV_AUDIO_UTILS_SITE=$(TOPDIR)/../multimedia/aml_audio_hal
DTV_AUDIO_UTILS_SITE_METHOD=local

DTV_AUDIO_UTILS_DEPENDENCIES=liblog libbinder aml-amaudioutils

define DTV_AUDIO_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D)/dtv_audio_utils all
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D)/dtv_audio_utils install
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D)/amadec all
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D)/amadec install
endef

$(eval $(generic-package))
