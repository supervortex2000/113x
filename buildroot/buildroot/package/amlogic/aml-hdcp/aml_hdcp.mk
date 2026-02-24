#############################################################
#
# HDCP driver
#
#############################################################
AML_HDCP_SITE = $(TOPDIR)/../vendor/amlogic/hdcp
AML_HDCP_SITE_METHOD = local

ifeq ($(BR2_aarch64),y)
	BIN_PATH = bin64
else
	BIN_PATH = bin
endif

define AML_HDCP_BUILD_CMDS
	@echo "aml hdcp comiple"
endef

define AML_HDCP_INSTALL_TARGET_CMDS
	-mkdir -p $(TARGET_DIR)/lib/teetz/
	$(INSTALL) -D -m 0755 $(@D)/ca/$(BIN_PATH)/tee_hdcp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/ta/$(TA_PATH)/*.ta $(TARGET_DIR)/lib/teetz/
	install -m 755 $(AML_HDCP_PKGDIR)/S60hdcp $(TARGET_DIR)/etc/init.d/S60hdcp
	install -m 755 $(AML_HDCP_PKGDIR)/S91hdcp_tx22_start $(TARGET_DIR)/etc/init.d/S91hdcp_tx22_start
endef

$(eval $(generic-package))
