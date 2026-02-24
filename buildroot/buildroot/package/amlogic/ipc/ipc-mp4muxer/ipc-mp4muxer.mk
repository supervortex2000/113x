#############################################################
#
# IPC MP4MUXER
#
#############################################################

IPC_MP4MUXER_VERSION = 1.0
IPC_MP4MUXER_SITE_METHOD = local
IPC_MP4MUXER_DEPENDENCIES += ipc-sdk
IPC_MP4MUXER_INSTALL_STAGING = YES

IPC_MP4MUXER_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/ipc-mp4muxer)
IPC_MP4MUXER_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/ipc-mp4muxer-prebuilt
IPC_MP4MUXER_PLATFORM = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

ifneq ($(IPC_MP4MUXER_LOCAL_SRC),)
IPC_MP4MUXER_SITE=$(IPC_MP4MUXER_LOCAL_SRC)

IPC_MP4MUXER_GIT_VERSION=$(shell \
			if [ -d $(IPC_MP4MUXER_SITE)/.git ]; then \
			   git -C $(IPC_MP4MUXER_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_MP4MUXER_BUILD_CMDS
	REVISION=$(IPC_MP4MUXER_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_MP4MUXER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libipc_mp4muxer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ipc_mp4muxer.h $(STAGING_DIR)/usr/include/
endef

define IPC_MP4MUXER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/libipc_mp4muxer.so $(TARGET_DIR)/usr/lib/
endef

define IPC_MP4MUXER_CREATE_PREBUILT_CMDS
	tar czf $(TARGET_DIR)/../images/ipc-mp4muxer-prebuilt.tgz \
		-C $(STAGING_DIR) \
		--transform "s@^\.@$(IPC_MP4MUXER_PLATFORM)@" \
		./usr/include/ipc_mp4muxer.h \
		./usr/lib/libipc_mp4muxer.so
endef

IPC_MP4MUXER_POST_INSTALL_STAGING_HOOKS += IPC_MP4MUXER_CREATE_PREBUILT_CMDS

else # prebuilt
IPC_MP4MUXER_SITE=$(IPC_MP4MUXER_LOCAL_PREBUILT)

define IPC_MP4MUXER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/$(IPC_MP4MUXER_PLATFORM)/usr/include/ipc_mp4muxer.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/$(IPC_MP4MUXER_PLATFORM)/usr/lib/libipc_mp4muxer.so $(STAGING_DIR)/usr/lib/
endef

define IPC_MP4MUXER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/$(IPC_MP4MUXER_PLATFORM)/usr/lib/libipc_mp4muxer.so $(TARGET_DIR)/usr/lib/
endef

endif


$(eval $(generic-package))
