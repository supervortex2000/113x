#############################################################
#
# AML PROVISION driver
#
#############################################################
AML_PROVISION_SITE = $(TOPDIR)/../vendor/amlogic/provision
AML_PROVISION_SITE_METHOD = local

ifeq ($(BR2_aarch64), y)
	BIN_DIR = $(@D)/ca/bin64
	LIB_DIR = $(@D)/ca/lib64
else
	BIN_DIR = $(@D)/ca/bin
	LIB_DIR = $(@D)/ca/lib
endif

define AML_PROVISION_BUILD_CMDS
	@echo "aml provision comiple"
endef

define AML_PROVISION_INSTALL_TARGET_CMDS
	-mkdir -p $(TARGET_DIR)/lib/optee_armtz/
	$(INSTALL) -D -m 0755 $(BIN_DIR)/tee_provision $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(BIN_DIR)/tee_key_inject $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(LIB_DIR)/libprovision.so $(TARGET_DIR)/lib
	$(INSTALL) -D -m 0755 $(@D)/ta/$(TA_PATH)/*.ta $(TARGET_DIR)/lib/optee_armtz/
	$(INSTALL) -m 0755 $(AML_PROVISION_PKGDIR)/S59provision_key_inject $(TARGET_DIR)/etc/init.d/S59provision_key_inject
endef

$(eval $(generic-package))
