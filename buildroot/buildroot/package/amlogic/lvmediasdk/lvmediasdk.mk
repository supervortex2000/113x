#
# lvmediasdk2.0 mod by private
#
ifeq ($(BR2_PACKAGE_LVMEDIASDK), y)

LVMEDIASDK_VERSION = 2.0
LVMEDIASDK_SITE = $(TOPDIR)/../vendor/amlogic/lvmediasdk
LVMEDIASDK_SITE_METHOD = local

define LVMEDIASDK_INSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define LVMEDIASDK_UNINSTALL_TARGET_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) uninstall
endef

$(eval $(generic-package))
endif
