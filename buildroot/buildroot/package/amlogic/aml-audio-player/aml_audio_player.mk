#############################################################
#
# amlogic audio player
#
# It can play audio with URL base on FFMPEG
#
#############################################################
AML_AUDIO_PLAYER_VERSION = 1.0
AML_AUDIO_PLAYER_SITE = $(TOPDIR)/../vendor/amlogic/aml_audio_player
AML_AUDIO_PLAYER_SITE_METHOD = local
AML_BOARD_NAMES := S400_SBR S400 AV400_SBR AV400_SPK S420 AD403 BA400 BA400_SBR T404
AML_SOC_BOARD_NAME = $(call qstrip,$(BR2_PACKAGE_AML_SOC_BOARD_NAME))
ifneq ($(filter $(AML_SOC_BOARD_NAME),$(AML_BOARD_NAMES)),)
    AML_AUDIO_PLAYER_DEPENDENCIES = ffmpeg-aml
else
    AML_AUDIO_PLAYER_DEPENDENCIES = ffmpeg
endif

define AML_AUDIO_PLAYER_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) all
endef

define AML_AUDIO_PLAYER_INSTALL_TARGET_CMDS
    $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
