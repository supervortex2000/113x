#
# AML_NN_AIAUDIO_MODEL
#
AML_NN_AIAUDIO_MODEL_VERSION = 1.0
AML_NN_AIAUDIO_MODEL_SITE = $(TOPDIR)/../vendor/amlogic/slt/npu_app/aiaudio_library/nn_data
AML_NN_AIAUDIO_MODEL_SITE_METHOD = local

NN_DATA_FOLDER=data/nn_data

define AML_NN_AIAUDIO_MODEL_BUILD_CMDS
	cd $(@D);
    $(INSTALL) -d $(TARGET_DIR)/$(NN_DATA_FOLDER);
endef

define AML_NN_WAKE_UP
	$(INSTALL) -D -m 0644 $(@D)/aml_wakeup/wakeup_cnn_1e.nb $(TARGET_DIR)/etc/nn_data/; \
	$(INSTALL) -D -m 0644 $(@D)/aml_wakeup/yes.wav $(TARGET_DIR)/etc/nn_data/;
endef

define AML_NN_AIAUDIO_MODEL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/nn_data
	$(AML_NN_WAKE_UP)

endef

$(eval $(generic-package))
