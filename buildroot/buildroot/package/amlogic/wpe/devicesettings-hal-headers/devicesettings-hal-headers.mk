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


DEVICESETTINGS_HAL_HEADERS_VERSION = a28dc688ff466eda7c1f51743d18a4aea506fac8
DEVICESETTINGS_HAL_HEADERS_SITE_METHOD = git
DEVICESETTINGS_HAL_HEADERS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/devicesettings/generic
DEVICESETTINGS_HAL_HEADERS_INSTALL_STAGING = YES
#DEVICESETTINGS_HAL_HEADERS_DEPENDENCIES = libxml2 dbus



define DEVICESETTINGS_HAL_HEADERS_INSTALL_STAGING_CMDS
    install -d $(STAGING_DIR)/usr/include/rdk/ds-hal
    install -m 0644 $(@D)/hal/include/*.h $(STAGING_DIR)/usr/include/rdk/ds-hal
    rm -f $(STAGING_DIR)/usr/include/rdk/ds-hal/*_sample.h
endef


#define DEVICESETTINGS-HAL-HEADERS_BUILD_CMDS

#    $(TARGET_MAKE_ENV) $(MAKE1) -C .
#endef

$(eval $(generic-package))
