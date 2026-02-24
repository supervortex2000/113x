#############################################################
#
# aml_dsp_util
#
#############################################################
AML_DSP_UTIL_VERSION:=0.0.1
AML_DSP_UTIL_SITE=$(TOPDIR)/../vendor/amlogic/rtos/dsp_util
AML_DSP_UTIL_SITE_METHOD=local
AML_DSP_UTIL_BUILD_DIR = $(BUILD_DIR)
AML_DSP_UTIL_INSTALL_STAGING = YES
AML_DSP_UTIL_DEFINE=

ifeq ($(BR2_PACKAGE_AML_DSP_UTIL_AUDIO_BRIDGE), y)
AML_DSP_UTIL_DEPENDENCIES+=alsa-lib
AML_DSP_UTIL_DEFINE+="AML_DSP_AUDIO_BRIDGE=y"
endif


define AML_DSP_UTIL_BUILD_CMDS
  $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(AML_DSP_UTIL_DEFINE) all
endef

define AML_DSP_UTIL_INSTALL_TARGET_CMDS
  $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(AML_DSP_UTIL_DEFINE) install
endef

$(eval $(generic-package))
