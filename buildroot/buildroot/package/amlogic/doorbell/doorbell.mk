############################################################
#
## DOORBELL
#
##############################################################

DOORBELL_VERSION = 1.0
DOORBELL_SITE = $(TOPDIR)/../vendor/amlogic/doorbell
DOORBELL_SITE_METHOD = local
DOORBELL_INSTALL_STAGING = NO

define DOORBELL_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define DOORBELL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/hostapp/hostapp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/hostapp_test/hostapp_test $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/uartcmd/uartcmd $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/uartcmd_client/uartcmd_client $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/bt_uart_hz/bt_uart_hz $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/wl_cmd/wl_cmd $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/tools/* $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/etc/bluetooth
	$(INSTALL) -D -m 755 $(@D)/bt/* $(TARGET_DIR)/etc/bluetooth/
	$(INSTALL) -D -m 755 $(@D)/scripts/* $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
