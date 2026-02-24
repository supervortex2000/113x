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


DEVICESETTINGS_HAL_AMLOGIC_VERSION = a28dc688ff466eda7c1f51743d18a4aea506fac8
DEVICESETTINGS_HAL_AMLOGIC_SITE_METHOD = git
DEVICESETTINGS_HAL_AMLOGIC_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/devicesettings/soc/amlogic/common
DEVICESETTINGS_HAL_AMLOGIC_INSTALL_STAGING = YES
DEVICESETTINGS_HAL_AMLOGIC_DEPENDENCIES = devicesettings-hal-headers



DEV_INCLUDE_DIRS = " \
    -I$(STAGING_DIR)/usr/include/rdk/ds-hal \
    -I$(STAGING_DIR)/usr/include/amports \
    -I$(STAGING_DIR)/usr/include/rdk/ds-rpc \
    -I$(STAGING_DIR)/usr/include/libdrm \
    "

CFLAGS += "-fPIC -D_REENTRANT -Wall ${DEV INCLUDE_DIRS}"
AMLOGIC_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(DEV_INCLUDE_DIRS)" \
	LDFLAGS=" "


define DEVICESETTINGS_HAL_AMLOGIC_INSTALL_TARGET_CMDS

    # Install our HAL .h files required by the 'generic' devicesettings
    cd $(@D)
    install -d $(STAGING_DIR)/usr/include/rdk/ds-hal
    for i in *Settings.h ; do
        install -m 0644 $i $(STAGING_DIR)/usr/include/rdk/ds-hal/
    done

    install -d $(TARGET_DIR)/usr/lib
    install -d $(TARGET_DIR)/opt/persistent/ds
    for i in *.so; do
        install -m 0755 $i $(TARGET_DIR)/usr/lib/`basename $i`
    done


    install -m 0755 $(@D)/hostData $(TARGET_DIR)/opt/persistent/ds/
    ln -s libds-hal.so $(TARGET_DIR)/libds-hal.so.0
    ln -s libds-hal.so $(TARGET_DIR)/usr/lib/libdshal.so


endef


define DEVICESETTINGS_HAL_AMLOGIC_BUILD_CMDS

    $(AMLOGIC_MAKE_ENV) $(MAKE) -C .
endef

$(eval $(generic-package))
