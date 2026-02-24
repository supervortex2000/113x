#############################################################
#
# IPC WEBSTREAM_SERVER
#
#############################################################

IPC_WEBSTREAM_SERVER_VERSION = 1.0
IPC_WEBSTREAM_SERVER_SITE = $(TOPDIR)/../vendor/amlogic/ipc/ipc-webstream-server
IPC_WEBSTREAM_SERVER_SITE_METHOD = local
IPC_WEBSTREAM_SERVER_INSTALL_STAGING = YES
IPC_WEBSTREAM_SERVER_DEPENDENCIES = host-pkgconf
IPC_WEBSTREAM_SERVER_DEPENDENCIES += ipc-sdk
IPC_WEBSTREAM_SERVER_DEPENDENCIES += libwebsockets

IPC_WEBSTREAM_SERVER_GIT_VERSION=$(shell \
			if [ -d $(IPC_WEBSTREAM_SERVER_SITE)/.git ]; then \
			   git -C $(IPC_WEBSTREAM_SERVER_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_WEBSTREAM_SERVER_BUILD_CMDS
	REVISION=$(IPC_WEBSTREAM_SERVER_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_WEBSTREAM_SERVER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libipc_webstreamserver.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ipc_webstream_server.h $(STAGING_DIR)/usr/include/
endef

define IPC_WEBSTREAM_SERVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/libipc_webstreamserver.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
