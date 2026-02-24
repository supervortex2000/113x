#
# libdrm_meson
#
LIBDRM_MESON_VERSION = 1.0
LIBDRM_MESON_SITE = $(TOPDIR)/../vendor/amlogic/libdrm_amlogic/meson
LIBDRM_MESON_SITE_METHOD = local
LIBDRM_MESON_DEPENDENCIES = libdrm

define LIBDRM_MESON_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(@D)/ all
endef

define LIBDRM_MESON_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC=$(TARGET_CC) -C $(@D)/ install
endef

define LIBDRM_MESON_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
