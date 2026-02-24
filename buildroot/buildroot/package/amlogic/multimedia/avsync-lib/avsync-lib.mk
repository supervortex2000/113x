#
# avsync-lib
#
AVSYNC_LIB_VERSION = 0.1
AVSYNC_LIB_SITE = $(TOPDIR)/../multimedia/avsync-lib/src
AVSYNC_LIB_SITE_METHOD = local
AVSYNC_LIB_INSTALL_STAGING = YES

define AVSYNC_LIB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(@D)/
endef

define AVSYNC_LIB_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libamlavsync.so $(STAGING_DIR)/usr/lib
endef

define AVSYNC_LIB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(@D)/ install
endef

define AVSYNC_LIB_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
