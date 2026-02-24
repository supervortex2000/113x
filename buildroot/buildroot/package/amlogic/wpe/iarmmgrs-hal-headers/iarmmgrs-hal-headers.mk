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


IARMMGRS_HAL_HEADERS_VERSION = stable2
IARMMGRS_HAL_HEADERS_SITE_METHOD = git
IARMMGRS_HAL_HEADERS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/iarmmgrs/generic
#IARMMGRS_HAL_HEADERS_INSTALL_STAGING = YES
IARMMGRS_HAL_HEADERS_INSTALL_TARGET = YES
#IARMMGRS_HAL_HEADERS_DEPENDENCIES = libxml2 dbus



define IARMMGRS_HAL_HEADERS_INSTALL_TARGET_CMDS
    echo $(STAGING_DIR)
    echo "###################################"
    install -d $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/hal/include/*.h               $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/ir/irMgrInternal.h            $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/ir/IrInputRemoteKeyCodes.h    $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/power/pwrlogger.h             $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/mfr/include/mfrMgr.h          $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/mfr/include/mfrTypes.h        $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/mfr/include/mfr_wifi_types.h  $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/mfr/include/mfr_wifi_api.h    $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/ir/include/irMgr.h            $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/sysmgr/include/sysMgr.h       $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/vrexmgr/include/vrexMgr.h     $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    install -m 0644 $(@D)/deviceUpdateMgr/include/deviceUpdateMgr.h $(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal
    echo "###################################"
    echo $(STAGING_DIR)
endef



$(eval $(generic-package))
