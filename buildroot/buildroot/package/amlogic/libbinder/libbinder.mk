LIBBINDER_VERSION = 0.1
LIBBINDER_SITE = $(TOPDIR)/../vendor/amlogic/aml_commonlib/libbinder
LIBBINDER_SITE_METHOD = local
LIBBINDER_DEPENDENCIES += linux liblog

LIBBINDER_SITE_DEPENDENCIES += android-tools liblog

define LIBBINDER_BUILD_CMDS
    $(MAKE) CXX=$(TARGET_CXX) CC=$(TARGET_CC) CFLAGS_EXTRA="$(TARGET_CFLAGS)" STRIP=$(TARGET_STRIP) -C $(@D) all
endef

define LIBBINDER_INSTALL_TARGET_CMDS
    $(MAKE) CXX=$(TARGET_CXX) CC=$(TARGET_CC) STRIP=$(TARGET_STRIP) -C $(@D) install
endef

define LIBBINDER_INSTALL_CLEAN_CMDS
    $(MAKE) CXX=$(TARGET_CXX) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
