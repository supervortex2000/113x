#
# logcat
#
LOGCAT_VERSION = 1.0
LOGCAT_SITE = $(TOPDIR)/../vendor/amlogic/aml_commonlib/logcat
LOGCAT_SITE_METHOD = local
LOGCAT_DEPENDENCIES += liblog

define LOGCAT_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) all
endef

define LOGCAT_INSTALL_TARGET_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) install
endef

define LOGCAT_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
