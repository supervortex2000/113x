#############################################################
#
# amlogic speaker process tools for avs
#
#############################################################
AML_SPEAKER_PROCESS_VERSION = 20191114
AML_SPEAKER_PROCESS_SITE = $(AML_SPEAKER_PROCESS_PKGDIR)/src
AML_SPEAKER_PROCESS_SITE_METHOD = local
AML_SPEAKER_PROCESS_DEPENDENCIES = avs-sdk

AML_SPEAKER_PROCESS_KWD_PATH = avs-sdk/shared/KWD/acsdkKWDImplementations
AML_SPEAKER_PROCESS_ASP_PATH = avs-sdk/shared/ASP/acsdkASP

ifeq ($(BR2_AVS_AMAZON_WWE),y)
AML_SPEAKER_PROCESS_CFLAGS = \
     "-I$(@D)/../$(AML_SPEAKER_PROCESS_KWD_PATH)/DSP/include/common/ \
     -I$(@D)/../$(AML_SPEAKER_PROCESS_ASP_PATH)/DSPC/include/EXT_WWE_DSP/ \
     -DEXT_WWE_DSP_KEY_WORD_DETECTOR=ON"
     AML_SPEAKER_PROCESS_LDFLAGS = "-L$(@D)/../$(AML_SPEAKER_PROCESS_ASP_PATH)/DSPC/lib/EXT_WWE_DSP/ -lAWELib"

#define AML_SPEAKER_PROCESS_INSTALL_TARGET_CMDS
#$(INSTALL) -m 0755 -D $(@D)/speaker_process  $(TARGET_DIR)/usr/bin
#$(INSTALL) -m 0755 -D $(@D)/EXT_WWE_DSP/speaker_processing.awb  $(TARGET_DIR)/usr/bin
#endef

endif

define AML_SPEAKER_PROCESS_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) CFLAGS=$(AML_SPEAKER_PROCESS_CFLAGS) LDFLAGS=$(AML_SPEAKER_PROCESS_LDFLAGS) -C $(@D) all
endef

define AML_SPEAKER_PROCESS_INSTALL_TARGET_CMDS
    $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
