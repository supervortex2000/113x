################################################################################
#
# Matter(CHIP)
#
################################################################################

CONNECTEDHOMEIP_SITE = $(TOPDIR)/../vendor/amlogic/connectedhomeip
CONNECTEDHOMEIP_SITE_METHOD = local
CONNECTEDHOMEIP_DEPENDENCIES = openssl avahi

export CONNECTEDHOMEIP_STAGING_DIR = $(STAGING_DIR)

BOARD_NAME = AMLOGIC

define CONNECTEDHOMEIP_BUILD_CMDS
    cd $(@D); \
	./scripts/examples/amlogic_example.sh ./examples/all-clusters-app/linux/ ./out/ $(BOARD_NAME) $(CONNECTEDHOMEIP_STAGING_DIR) $(BR2_TOOLCHAIN_EXTERNAL_PREFIX); \
	./scripts/examples/amlogic_example.sh ./examples/chip-tool/ ./out/ $(BOARD_NAME) $(CONNECTEDHOMEIP_STAGING_DIR) $(BR2_TOOLCHAIN_EXTERNAL_PREFIX); \
	./scripts/examples/amlogic_example.sh ./examples/shell/standalone/ ./out/ $(BOARD_NAME) $(CONNECTEDHOMEIP_STAGING_DIR) $(BR2_TOOLCHAIN_EXTERNAL_PREFIX); \
	./scripts/examples/amlogic_example.sh ./examples/shell/amlogic/ ./out/ $(BOARD_NAME) $(CONNECTEDHOMEIP_STAGING_DIR) $(BR2_TOOLCHAIN_EXTERNAL_PREFIX);
endef

define CONNECTEDHOMEIP_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(CONNECTEDHOMEIP_SITE)/scripts/S91matter \
		$(TARGET_DIR)/etc/init.d/S91matter
	$(INSTALL) -D -m 755 \
		$(@D)/out/$(BOARD_NAME)/chip-tool \
		$(TARGET_DIR)/usr/bin/chip-tool
	$(INSTALL) -D -m 755 \
		$(@D)/out/$(BOARD_NAME)/chip-all-clusters-app \
		$(TARGET_DIR)/usr/bin/chip-all-clusters-app
	$(INSTALL) -D -m 755 \
		$(@D)/out/$(BOARD_NAME)/chip-shell \
		$(TARGET_DIR)/usr/bin/chip-shell
	$(INSTALL) -D -m 755 \
		$(@D)/out/$(BOARD_NAME)/chip-shell-aml \
		$(TARGET_DIR)/usr/bin/chip-shell-aml
endef

$(eval $(generic-package))
