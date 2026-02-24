################################################################################
#
# libwebrtc_apm
#
################################################################################

WEBRTC_APM_VERSION = 0.3.1
WEBRTC_APM_SOURCE = webrtc-audio-processing-$(WEBRTC_APM_VERSION).tar.xz
WEBRTC_APM_SITE = http://freedesktop.org/software/pulseaudio/webrtc-audio-processing
WEBRTC_APM_INSTALL_STAGING = YES
WEBRTC_APM_DEST_DIR = $(STAGING_DIR)/usr/include/webrtc

define WEBRTC_APM_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D)
endef

define WEBRTC_APM_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libwebrtc_apm.so $(TARGET_DIR)/usr/lib/
endef

define WEBRTC_APM_INSTALL_STAGING_CMDS
    $(RM) -r $(WEBRTC_APM_DEST_DIR)
    mkdir -p $(WEBRTC_APM_DEST_DIR)
    $(INSTALL) -D -m 0644 $(@D)/libwebrtc_apm.so \
        $(STAGING_DIR)/usr/lib/libwebrtc_apm.so
    $(INSTALL) -D -m 0644 $(@D)/webrtc/modules/audio_processing/aec/aec_core.h \
        $(WEBRTC_APM_DEST_DIR)/modules/audio_processing/aec/aec_core.h
    $(INSTALL) -D -m 0644 $(@D)/webrtc/typedefs.h \
        $(WEBRTC_APM_DEST_DIR)/typedefs.h
    $(INSTALL) -D -m 0644 $(@D)/webrtc/modules/audio_processing/aec/include/echo_cancellation.h \
        $(WEBRTC_APM_DEST_DIR)/modules/audio_processing/aec/include/echo_cancellation.h
    $(INSTALL) -D -m 0644 $(@D)/webrtc/modules/audio_processing/ns/include/noise_suppression.h \
        $(WEBRTC_APM_DEST_DIR)/modules/audio_processing/ns/include/noise_suppression.h
    $(INSTALL) -D -m 0644 $(@D)/webrtc/modules/audio_processing/agc/legacy/gain_control.h \
        $(WEBRTC_APM_DEST_DIR)/modules/audio_processing/agc/legacy/gain_control.h
endef

define WEBRTC_APM_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
