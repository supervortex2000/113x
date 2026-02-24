#
# aml_eq_drc_effects
#
AUDIO_EFFECTS_VERSION = 1.0
AUDIO_EFFECTS_SITE = $(TOPDIR)/../multimedia/audio_effects/src
AUDIO_EFFECTS_SITE_METHOD = local
AUDIO_EFFECTS_DIR = $(BUILD_DIR)
AUDIO_EFFECTS_INSTALL_STAGING = YES

define AUDIO_EFFECTS_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) all
endef

define AUDIO_EFFECTS_INSTALL_TARGET_CMDS
    $(MAKE) -C $(@D) install
    #$(INSTALL) -D -m 0755 $(@D)/libaudio_effects.so $(TARGET_DIR)/usr/lib/libaudio_effects.so
endef

define AUDIO_EFFECTS_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
