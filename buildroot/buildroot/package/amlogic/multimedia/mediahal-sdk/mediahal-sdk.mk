#############################################################
#
# mediahal_sdk
#
#############################################################
MEDIAHAL_SDK_VERSION:=1.0.0
MEDIAHAL_SDK_SITE=$(TOPDIR)/../multimedia/mediahal-sdk
MEDIAHAL_SDK_SITE_METHOD=local
MEDIAHAL_SDK_INSTALL_STAGING := YES

CC_TARGET_ABI_:= $(call qstrip,$(BR2_GCC_TARGET_ABI))
CC_TARGET_FLOAT_ABI_ := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

ifeq ($(BR2_PACKAGE_MEDIAHAL_SDK_RESMAN), y)
define MEDIAHAL_SDK_RESMAN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_resman.so $(TARGET_DIR)/usr/lib/
endef
define MEDIAHAL_SDK_RESMAN_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/noarch/include/resourcemanage.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_resman.so $(STAGING_DIR)/usr/lib/
endef
endif

ifeq ($(BR2_PACKAGE_MEDIAHAL_SDK_VIDEODEC), y)
MEDIAHAL_SDK_DEPENDENCIES += libevent
define MEDIAHAL_SDK_VIDEODEC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_videodec.so $(TARGET_DIR)/usr/lib/
endef
define MEDIAHAL_SDK_VIDEODEC_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/noarch/include/AmVideoDecBase.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_videodec.so $(STAGING_DIR)/usr/lib/
endef
endif

ifeq ($(BR2_PACKAGE_MEDIAHAL_SDK_MEDIASYNC), y)
define MEDIAHAL_SDK_MEDIASYNC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_mediasync.so $(TARGET_DIR)/usr/lib/
endef
define MEDIAHAL_SDK_MEDIASYNC_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/noarch/include/MediaSyncInterface.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_mediasync.so $(STAGING_DIR)/usr/lib/
endef
endif

ifeq ($(BR2_PACKAGE_MEDIAHAL_SDK_TSPLAYER), y)
MEDIAHAL_SDK_DEPENDENCIES += hal-audio-service
define MEDIAHAL_SDK_TSPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_tsplayer.so $(TARGET_DIR)/usr/lib/
endef
define MEDIAHAL_SDK_TSPLAYER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/noarch/include/AmTsPlayer.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 0644 $(@D)/prebuilt/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/libmediahal_tsplayer.so $(STAGING_DIR)/usr/lib/
endef
endif

define MEDIAHAL_SDK_INSTALL_TARGET_CMDS
	$(MEDIAHAL_SDK_RESMAN_INSTALL_TARGET_CMDS)
	$(MEDIAHAL_SDK_VIDEODEC_INSTALL_TARGET_CMDS)
	$(MEDIAHAL_SDK_MEDIASYNC_INSTALL_TARGET_CMDS)
	$(MEDIAHAL_SDK_TSPLAYER_INSTALL_TARGET_CMDS)
endef

define MEDIAHAL_SDK_INSTALL_STAGING_CMDS
	$(MEDIAHAL_SDK_RESMAN_INSTALL_STAGING_CMDS)
	$(MEDIAHAL_SDK_VIDEODEC_INSTALL_STAGING_CMDS)
	$(MEDIAHAL_SDK_MEDIASYNC_INSTALL_STAGING_CMDS)
	$(MEDIAHAL_SDK_TSPLAYER_INSTALL_STAGING_CMDS)
endef

$(eval $(generic-package))
