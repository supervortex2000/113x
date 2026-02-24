#
# AML_NN_AIAUDIO
#
AML_NN_AIAUDIO_VERSION = 1.0
AML_NN_AIAUDIO_SITE = $(TOPDIR)/../vendor/amlogic/slt/npu_app/aiaudio_library/source_code
AML_NN_AIAUDIO_SITE_METHOD = local
AML_NN_AIAUDIO_INSTALL_STAGING = YES
AML_NN_AIAUDIO_DEPENDENCIES = npu

define AML_NN_AIAUDIO_BUILD_CMDS
    cd $(@D);mkdir -p obj;$(MAKE) CC=$(TARGET_CC)
endef

define AML_NN_AIAUDIO_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/etc/nn_data
    $(INSTALL) -D -m 0644 $(@D)/libnn_audio.so $(TARGET_DIR)/usr/lib/libnn_audio.so
endef

define AML_NN_AIAUDIO_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libnn_audio.so $(STAGING_DIR)/usr/lib/libnn_audio.so
    $(INSTALL) -D -m 0644 $(@D)/include/nn_detect.h $(STAGING_DIR)/usr/include/nn_detect.h
    $(INSTALL) -D -m 0644 $(@D)/include/nn_detect_common.h $(STAGING_DIR)/usr/include/nn_detect_common.h
    $(INSTALL) -D -m 0644 $(@D)/include/nn_detect_utils.h $(STAGING_DIR)/usr/include/nn_detect_utils.h
    $(INSTALL) -D -m 0644 $(@D)/include/nn_sdk.h $(STAGING_DIR)/usr/include/nn_sdk.h
    $(INSTALL) -D -m 0644 $(@D)/include/nn_util.h $(STAGING_DIR)/usr/include/nn_util.h

endef

define AML_NN_AIAUDIO_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))


