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


DEVICESETTINGS_VERSION = stable2
DEVICESETTINGS_SITE_METHOD = git
DEVICESETTINGS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/devicesettings/generic
DEVICESETTINGS_AUTORECONF = YES
DEVICESETTINGS_DEPENDENCIES =  devicesettings-hal-llama iarmbus
#DEVICESETTINGS_BUILD_CMDS = true

DEV_INCLUDE_DIRS_APPEND =  \
    -I$(@D)/rpc/include \
    -I$(@D)/ds/include \
    -I$(@D)/hal/include \
    -I$(STAGING_DIR)/usr/include \
    -I$(STAGING_DIR)/usr/include/rdk/iarmbus \
    -I$(STAGING_DIR)/usr/include/rdk/logger \
    -I$(STAGING_DIR)/usr/include/rdk/ds-rpc \
    -I$(STAGING_DIR)/usr/include/rdk/ds-hal \
    -I$(STAGING_DIR)/usr/include/glib-2.0 \
    -I$(STAGING_DIR)/usr/include/directfb \
    -I$(STAGING_DIR)/usr/include/glib-2.0/include \
    -I$(STAGING_DIR)/usr/include/logger




DRDK_SHAL_NAME_DEF= -DRDK_DSHAL_NAME=\"\\\"libds-hal.so.0\\\"\"

OUTPUT_FORMAT=-DDEVICESETTINGS_DEFAULT_RESOLUTION=\"\\\"1080p60\\\"\"

DEVICESETTINGS_CONF_OPTS += CFLAGS="$(DEV_INCLUDE_DIRS_APPEND) $(TARGET_CFLAGS) -DYOCTO_BUILD  \
	$(DRDK_SHAL_NAME_DEF) \
	-fPIC -D_REENTRANT -Wall \
	$(OUTPUT_FORMAT) "



DEVICESETTINGS_CONF_OPTS += LDFLAGS="$(TARGET_LDFLAGS)  \
        -lpthread -lglib-2.0 -L. -lIARMBus -ldl "



define DEVICESETTINGS_INSTALL_TARGET_CMDS
    install -d $(STAGING_DIR)/usr/include/rdk/ds
    install -m 0644 $(@D)/ds/include/*.h* $(STAGING_DIR)/usr/include/rdk/ds
    install -m 0644 $(@D)/ds/*.h* $(STAGING_DIR)/usr/include/rdk/ds

    install -d $(STAGING_DIR)/usr/include/rdk/ds-rpc
    install -m 0644 $(@D)/rpc/include/*.h* $(STAGING_DIR)/usr/include/rdk/ds-rpc

    install -d $(TARGET_DIR)/usr/lib
    install -d $(STAGING_DIR)/usr/lib
    install -m 0755 $(@D)/rpc/cli/*.so  $(TARGET_DIR)/usr/lib
    install -m 0755 $(@D)/rpc/cli/*.so  $(STAGING_DIR)/usr/lib
    install -m 0755 $(@D)/rpc/srv/*.so  $(TARGET_DIR)/usr/lib
    install -m 0755 $(@D)/rpc/srv/*.so  $(STAGING_DIR)/usr/lib
    install -m 0755 $(@D)/ds/*.so  $(TARGET_DIR)/usr/lib
    install -m 0755 $(@D)/ds/*.so  $(STAGING_DIR)/usr/lib
endef


define DEVICESETTINGS_REMOVE_MAKEFILE
	rm -rf  $(@D)/Makefile
endef

DEVICESETTINGS_PRE_CONFIGURE_HOOKS += DEVICESETTINGS_REMOVE_MAKEFILE






define DEVICESETTINGS_BUILD_CMDS
	#rm -rf $(@D)/hal
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/rpc/cli  $(TARGET_CONFIGURE_OPTS)  CFLAGS="$(TARGET_CFLAGS) -fPIC $(DEV_INCLUDE_DIRS_APPEND) "
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/rpc/srv  $(TARGET_CONFIGURE_OPTS)  CFLAGS="$(TARGET_CFLAGS) -fPIC $(DEV_INCLUDE_DIRS_APPEND) $(DRDK_SHAL_NAME_DEF) "
        $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/ds  $(TARGET_CONFIGURE_OPTS)  CFLAGS="$(TARGET_CFLAGS) -fPIC $(DEV_INCLUDE_DIRS_APPEND) -std=c++11"

endef




$(eval $(generic-package))
#$(eval $(autotools-package))
