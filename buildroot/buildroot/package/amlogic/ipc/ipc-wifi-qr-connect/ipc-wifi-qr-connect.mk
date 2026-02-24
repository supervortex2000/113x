#############################################################
#
# IPC WIFI QR CONNECT
#
#############################################################

IPC_WIFI_QR_CONNECT_VERSION = 1.0
IPC_WIFI_QR_CONNECT_SITE = $(TOPDIR)/../vendor/amlogic/ipc/ipc-wifi-qr-connect
IPC_WIFI_QR_CONNECT_SITE_METHOD = local
IPC_WIFI_QR_CONNECT_INSTALL_STAGING = NO
IPC_WIFI_QR_CONNECT_DEPENDENCIES = host-pkgconf quirc libjpeg libpng

define IPC_WIFI_QR_CONNECT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_WIFI_QR_CONNECT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/ipc
	$(INSTALL) -D -m 755 $(@D)/ipc-qr-scanner $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/startup.sh $(TARGET_DIR)/etc/init.d/S82ipc-wifi-qr-connect
	cp -af $(@D)/audio $(TARGET_DIR)/etc/ipc/
endef

$(eval $(generic-package))
