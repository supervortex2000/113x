################################################################################
#
# netlfix prebuilt
#
################################################################################


NETFLIX_TA_BIN_VERSION = 1.0
NETFLIX_TA_BIN_SITE = $(TOPDIR)/../multimedia/libmediadrm/netflix_ta-bin/prebuilt
NETFLIX_TA_BIN_SITE_METHOD = local
NETFLIX_TA_BIN_INSTALL_TARGET := YES
NETFLIX_TA_BIN_INSTALL_STAGING := FALSE
NETFLIX_TA_BIN_DEPENDENCIES = tdk

CC_TARGET_ABI_:= $(call qstrip,$(BR2_GCC_TARGET_ABI))
CC_TARGET_FLOAT_ABI_ := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define NETFLIX_TA_BIN_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/noarch/ta/$(TA_PATH)/*.ta $(TARGET_DIR)/lib/teetz/
    $(INSTALL) -D -m 0755 $(@D)/$(BR2_ARCH).$(CC_TARGET_ABI_).$(CC_TARGET_FLOAT_ABI_)/esn_provision $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
