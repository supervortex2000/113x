#
# logwrapper
#
LOGWRAPPER_VERSION = 1.0
LOGWRAPPER_SITE = $(TOPDIR)/../vendor/amlogic/aml_commonlib/logwrapper
LOGWRAPPER_SITE_METHOD = local
LOGWRAPPER_INSTALL_STAGING = YES

define LOGWRAPPER_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) all
endef

define LOGWRAPPER_INSTALL_TARGET_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) install
endef

define LOGWRAPPER_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) CXX=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
