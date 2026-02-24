AML_BT_CT_VERSION=1.0
AML_BT_CT_SITE_METHOD=local
AML_BT_CT_SITE=$(TOPDIR)/../vendor/amlogic/aml_bt_ct

define AML_BT_CT_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(@D)/tools
endef

define AML_BT_CT_INSTALL_TARGET_CMDS
	mkdir -p /etc
	$(INSTALL) -D -m 0644 $(@D)/tools/aml_bt_hciattach     $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0644 $(@D)/tools/fw_out.info     $(TARGET_DIR)/etc
	$(INSTALL) -D -m 0644 $(@D)/tools/fw_out.bin     $(TARGET_DIR)/etc
endef

$(eval $(generic-package))
