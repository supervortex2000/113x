################################################################################
#
# quirc
#
################################################################################

QUIRC_VERSION = 744372e5
QUIRC_SITE = $(call github,dlbeer,quirc,$(QUIRC_VERSION))
QUIRC_LICENSE = Daniel Beer
QUIRC_LICENSE_FILES = LICENSE
QUIRC_INSTALL_STAGING = YES

define QUIRC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) libquirc.so
endef

define QUIRC_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libquirc.so.1.0 $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/lib/quirc.h $(STAGING_DIR)/usr/include/
	ln -sf libquirc.so.1.0 $(STAGING_DIR)/usr/lib/libquirc.so
endef

define QUIRC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 644 $(@D)/libquirc.so.1.0 $(TARGET_DIR)/usr/lib/
	ln -sf libquirc.so.1.0 $(TARGET_DIR)/usr/lib/libquirc.so
endef
$(eval $(generic-package))
