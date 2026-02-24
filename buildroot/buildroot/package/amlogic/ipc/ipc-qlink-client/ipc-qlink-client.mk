#############################################################
#
# IPC QLINK_CLIENT
#
#############################################################

IPC_QLINK_CLIENT_VERSION = 1.0
IPC_QLINK_CLIENT_SITE_METHOD = local
IPC_QLINK_CLIENT_INSTALL_STAGING = NO
IPC_QLINK_CLIENT_DEPENDENCIES = host-pkgconf
IPC_QLINK_CLIENT_DEPENDENCIES += ipc-property
IPC_QLINK_CLIENT_DEPENDENCIES += cjson openssl

IPC_QLINK_CLIENT_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/ipc-qlink-client)
IPC_QLINK_CLIENT_LOCAL_PREBUILT = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/ipc-qlink-client-prebuilt)
IPC_QLINK_CLIENT_PREBUILT_DIRECTORY = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
IPC_QLINK_CLIENT_SITE=$(IPC_QLINK_CLIENT_LOCAL_PREBUILT)

ifneq ($(IPC_QLINK_CLIENT_LOCAL_SRC),)
IPC_QLINK_CLIENT_SITE=$(IPC_QLINK_CLIENT_LOCAL_SRC)

IPC_QLINK_CLIENT_GIT_VERSION=$(shell \
			if [ -d $(IPC_QLINK_CLIENT_SITE)/.git ]; then \
			   git -C $(IPC_QLINK_CLIENT_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_QLINK_CLIENT_BUILD_CMDS
	REVISION=$(IPC_QLINK_CLIENT_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_QLINK_CLIENT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/ipc
	$(INSTALL) -D -m 755 $(@D)/ipc-qlink-client $(TARGET_DIR)/usr/bin/
	cp -af $(@D)/scripts $(TARGET_DIR)/etc/ipc/
endef

ifneq ($(IPC_QLINK_CLIENT_LOCAL_PREBUILT),)
define IPC_QLINK_CLIENT_UPDATE_PREBUILT_CMDS

	# DO NOT remove the first empty line
	mkdir -p $(IPC_QLINK_CLIENT_LOCAL_PREBUILT)/$(IPC_QLINK_CLIENT_PREBUILT_DIRECTORY)/usr/bin/
	$(INSTALL) -m 755 -D $(@D)/ipc-qlink-client $(IPC_QLINK_CLIENT_LOCAL_PREBUILT)/$(IPC_QLINK_CLIENT_PREBUILT_DIRECTORY)/usr/bin/
	cp -a $(@D)/scripts $(IPC_QLINK_CLIENT_LOCAL_PREBUILT)/
	cp -a $(@D)/README.md $(IPC_QLINK_CLIENT_LOCAL_PREBUILT)/
endef

IPC_QLINK_CLIENT_INSTALL_TARGET_CMDS += $(IPC_QLINK_CLIENT_UPDATE_PREBUILT_CMDS)
endif

else # prebuilt

IPC_QLINK_CLIENT_SITE=$(TOPDIR)/../vendor/amlogic/ipc/ipc-qlink-client-prebuilt
define IPC_QLINK_CLIENT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/ipc
	$(INSTALL) -D -m 755 $(@D)/$(IPC_QLINK_CLIENT_PREBUILT_DIRECTORY)/usr/bin/ipc-qlink-client $(TARGET_DIR)/usr/bin/
	cp -af $(@D)/scripts $(TARGET_DIR)/etc/ipc/
endef

endif

$(eval $(generic-package))
