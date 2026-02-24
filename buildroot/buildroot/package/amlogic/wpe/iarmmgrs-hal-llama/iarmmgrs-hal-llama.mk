# ============================================================================
# RDK MANAGEMENT, LLC CONFIDENTIAL AND PROPRIETARY
# ============================================================================
# This file (and its contents) are the intellectual property of RDK Management, LLC.
# It may not be used, copied, distributed or otherwise  disclosed in whole or in
# part without the express written permission of RDK Management, LLC.
# ============================================================================
# Copyright (c) 2016 RDK Management, LLC. All rights reserved.
# ============================================================================
#


IARMMGRS_HAL_LLAMA_VERSION = stable2
IARMMGRS_HAL_LLAMA_SITE_METHOD = git
IARMMGRS_HAL_LLAMA_SITE=ssh://gerrit.teamccp.com:29418/rdk/components/generic/iarmmgrs/soc/amlogic/common
#IARMMGRS_HAL_LLAMA_INSTALL_STAGING = YES
#IARMMGRS_HAL_LLAMA_INSTALL_TARGET = NO
IARMMGRS_HAL_LLAMA_AUTORECONF = YES

IARMMGRS_HAL_LLAMA_DEPENDENCIES = iarmmgrs-hal-headers iarmbus

IARMMGRS_INCLUDE_DIRS_APPEND =  \
    -I$(STAGING_DIR)/usr/include \
    -I$(STAGING_DIR)/usr/include/glib-2.0 \
    -I$(STAGING_DIR)/usr/include/directfb \
    -I$(STAGING_DIR)/usr/lib/glib-2.0/include \
    -I$(STAGING_DIR)/usr/include/logger \
    -I$(STAGING_DIR)/usr/include/rdk/iarmbus


IARMMGRS_HAL_LLAMA_CONF_OPTS = \
	CFLAGS="$(TARGET_CFLAGS) $(IARMMGRS_INCLUDE_DIRS_APPEND)" \
	--includedir=$(STAGING_DIR)  \
	--libdir=$(STAGING_DIR)/usr \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR)




define IARMMGRS_HAL_LLAMA_INSTALL_TARGET_CMDS

        install -m 0755 -d $(TARGET_DIR)/etc
        install  $(@D)/etc/keymap.conf  $(TARGET_DIR)/etc
        install  $(@D)/etc/remote3.conf $(TARGET_DIR)/etc/remote.conf
        install -d $(STAGING_DIR)/usr/lib
	install -d $(TARGET_DIR)/usr/lib
	install -m 0755 $(@D)/ir/.libs/*.so*  $(STAGING_DIR)/usr/lib
	install -m 0755 $(@D)/power/.libs/*.so*  $(STAGING_DIR)/usr/lib
	install -m 0755 $(@D)/deepsleep/.libs/*.so*  $(STAGING_DIR)/usr/lib

	install -m 0755 $(@D)/ir/.libs/*.so*  $(TARGET_DIR)/usr/lib
	install -m 0755 $(@D)/power/.libs/*.so*  $(TARGET_DIR)/usr/lib
	install -m 0755 $(@D)/deepsleep/.libs/*.so*  $(TARGET_DIR)/usr/lib
endef




$(eval $(autotools-package))
