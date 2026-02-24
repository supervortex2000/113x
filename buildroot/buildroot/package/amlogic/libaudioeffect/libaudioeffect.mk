#############################################################
#
# libaudioeffect
#
#############################################################
LIBAUDIOEFFECT_VERSION:=0.1
LIBAUDIOEFFECT_SITE=$(TOPDIR)/../multimedia/libaudioeffect
LIBAUDIOEFFECT_SITE_METHOD=local

LIBAUDIOEFFECT_DEPENDENCIES = aml-amaudioutils

export LIBAUDIOEFFECT_BUILD_DIR = $(BUILD_DIR)
export LIBAUDIOEFFECT_STAGING_DIR = $(STAGING_DIR)
export LIBAUDIOEFFECT_TARGET_DIR = $(TARGET_DIR)
export LIBAUDIOEFFECT_BR2_ARCH = $(BR2_ARCH)

define LIBAUDIOEFFECT_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D) all
    $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D) install
endef

$(eval $(generic-package))
