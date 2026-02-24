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


DEVICESETTINGS_HAL_LLAMA_VERSION = stable2
DEVICESETTINGS_HAL_LLAMA_SITE_METHOD = git
DEVICESETTINGS_HAL_LLAMA_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/devicesettings/soc/amlogic/common
DEVICESETTINGS_HAL_LLAMA_INSTALL_STAGING=YES
#DEVICESETTINGS_HAL_LLAMA_INSTALL_TARGET=NO
#DEVICESETTINGS_HAL_LLAMA_BUILD_CMDS = true

DEVICESETTINGS_HAL_LLAMA_DEPENDENCIES = devicesettings-hal-headers fpdriverlib aml-tvserver



DEV_INCLUDE_APPEND = \
	-I$(STAGING_DIR)/usr/include/rdk/ds-hal \
	-I$(STAGING_DIR)/usr/include/amports \
	-I$(STAGING_DIR)/usr/include/rdk/ds-rpc \
	-I$(STAGING_DIR)/usr/include/libdrm





define DEVICESETTINGS_HAL_LLAMA_INSTALL_STAGING_CMDS

    # Install our HAL .h files required by the 'generic' devicesettings
    install -d $(STAGING_DIR)/usr/include/rdk/ds-hal
    install -m 0644 $(@D)/*Settings.h $(STAGING_DIR)/usr/include/rdk/ds-hal/

    install -d $(STAGING_DIR)/usr/lib
    install -m 0755 $(@D)/libds-hal.so $(STAGING_DIR)/usr/lib
endef


define DEVICESETTINGS_HAL_LLAMA_INSTALL_TARGET_CMDS

    install -d $(TARGET_DIR)/usr/lib
    install -d $(TARGET_DIR)/opt/persistent/ds

    install -m 0755 $(@D)/*.so  $(TARGET_DIR)/usr/lib/

    install -m 0755 $(@D)/hostData $(TARGET_DIR)/opt/persistent/ds/
    rm -f  $(TARGET_DIR)/usr/lib/libdshal.so
    rm -f  $(TARGET_DIR)/usr/lib/libds-hal.so.0
    ln -s  libds-hal.so $(TARGET_DIR)/usr/lib/libds-hal.so.0
    ln -s  libds-hal.so $(TARGET_DIR)/usr/lib/libdshal.so


endef

define DEVICESETTINGS_HAL_LLAMA_BUILD_CMDS

	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
				CFLAGS="$(TARGET_CFLAGS) -fPIC $(DEV_INCLUDE_APPEND)"

endef


$(eval $(generic-package))
