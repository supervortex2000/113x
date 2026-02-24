#
# DNCNN
#
AML_NN_DNCNN_VERSION = 1.0
AML_NN_DNCNN_SITE = $(TOPDIR)/../vendor/amlogic/slt/npu_app/DNCNN/DnCnn-test
AML_NN_DNCNN_SITE_METHOD = local
AML_NN_DNCNN_DEPENDENCIES = npu jpeg

define AML_NN_DNCNN_BUILD_CMDS
    cd $(@D);mkdir -p obj;$(MAKE) CC=$(TARGET_CC) TARGET_KERNEL_CROSS=$(TARGET_KERNEL_CROSS)
endef

define AML_NN_DNCNN_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/run.sh $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/DnCNN.export.data $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/dncnn $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/output.bin $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/input.bin $(TARGET_DIR)/usr/bin/DNCNN
    $(INSTALL) -D -m 0755 $(@D)/inp_2.tensor $(TARGET_DIR)/usr/bin/DNCNN
endef

define AML_NN_DNCNN_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) TARGET_KERNEL_CROSS=$(TARGET_KERNEL_CROSS) -C $(@D) clean
endef

$(eval $(generic-package))
