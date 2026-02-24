#############################################################
#
# IPC RTSP SERVER
#
#############################################################

IPC_RTSP_SERVER_VERSION = 1.0
IPC_RTSP_SERVER_SITE_METHOD = local
IPC_RTSP_SERVER_DEPENDENCIES += ipc-sdk
IPC_RTSP_SERVER_INSTALL_STAGING = YES

IPC_RTSP_SERVER_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/ipc-rtsp-server)
IPC_RTSP_SERVER_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/ipc-rtsp-server-prebuilt
IPC_RTSP_SERVER_PLATFORM = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

ifneq ($(IPC_RTSP_SERVER_LOCAL_SRC),)
IPC_RTSP_SERVER_SITE=$(IPC_RTSP_SERVER_LOCAL_SRC)

IPC_RTSP_SERVER_GIT_VERSION=$(shell \
			if [ -d $(IPC_RTSP_SERVER_SITE)/.git ]; then \
			   git -C $(IPC_RTSP_SERVER_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_RTSP_SERVER_BUILD_CMDS
	REVISION=$(IPC_RTSP_SERVER_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_RTSP_SERVER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libipc_rtspserver.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ipc_rtsp_server.h $(STAGING_DIR)/usr/include/
endef

define IPC_RTSP_SERVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/libipc_rtspserver.so $(TARGET_DIR)/usr/lib/
endef

define IPC_RTSP_SERVER_CREATE_PREBUILT_CMDS
	tar czf $(TARGET_DIR)/../images/ipc-rtsp-server-prebuilt.tgz \
		-C $(STAGING_DIR) \
		--transform "s@^\.@$(IPC_RTSP_SERVER_PLATFORM)@" \
		./usr/include/ipc_rtsp_server.h \
		./usr/lib/libipc_rtspserver.so
endef

IPC_RTSP_SERVER_POST_INSTALL_STAGING_HOOKS += IPC_RTSP_SERVER_CREATE_PREBUILT_CMDS

else # prebuilt
IPC_RTSP_SERVER_SITE=$(IPC_RTSP_SERVER_LOCAL_PREBUILT)

define IPC_RTSP_SERVER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/$(IPC_RTSP_SERVER_PLATFORM)/usr/include/ipc_rtsp_server.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/$(IPC_RTSP_SERVER_PLATFORM)/usr/lib/libipc_rtspserver.so $(STAGING_DIR)/usr/lib/
endef

define IPC_RTSP_SERVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/$(IPC_RTSP_SERVER_PLATFORM)/usr/lib/libipc_rtspserver.so $(TARGET_DIR)/usr/lib/
endef

endif


$(eval $(generic-package))
