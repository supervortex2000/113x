#
# AML_NN_AIAUDIO_DEMO
#
AML_NN_AIAUDIO_DEMO_VERSION = 1.0
AML_NN_AIAUDIO_DEMO_SITE = $(TOPDIR)/../vendor/amlogic/slt/npu_app/aiaudio_library/sample_demo
AML_NN_AIAUDIO_DEMO_SITE_METHOD = local
AML_NN_AIAUDIO_DEMO_INSTALL_STAGING = YES
AML_NN_AIAUDIO_DEMO_DEPENDENCIES = npu aml-nn-aiaudio-model aml-nn-aiaudio

define AML_NN_AIAUDIO_DEMO_BUILD_CMDS
    cd $(@D);mkdir -p obj;$(MAKE) CC=$(TARGET_CC)
endef

define AML_NN_AIAUDIO_DEMO_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/aiaudio_test $(TARGET_DIR)/usr/bin/aiaudio_test
endef

define AML_NN_AIAUDIO_DEMO_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) TARGET_KERNEL_CROSS=$(TARGET_KERNEL_CROSS) -C $(@D) clean
endef

$(eval $(generic-package))
