#############################################################
#
# IPC System Service
#
#############################################################

IPC_SYSTEM_SERVICE_VERSION = 1.0
IPC_SYSTEM_SERVICE_SITE = $(TOPDIR)/../vendor/amlogic/ipc/ipc_system_service
IPC_SYSTEM_SERVICE_SITE_METHOD = local

IPC_SYSTEM_SERVICE_GIT_VERSION=$(shell \
			if [ -d $(IPC_SYSTEM_SERVICE_SITE)/.git ]; then \
			   git -C $(IPC_SYSTEM_SERVICE_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_SYSTEM_SERVICE_BUILD_CMDS
	REVISION=$(IPC_SYSTEM_SERVICE_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_SYSTEM_SERVICE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/ipc
	$(INSTALL) -D -m 755 $(@D)/ipc-system-service $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/startup.sh $(TARGET_DIR)/etc/init.d/S45ipc-system-service
	cp -af $(@D)/scripts $(TARGET_DIR)/etc/ipc/
endef

$(eval $(generic-package))
