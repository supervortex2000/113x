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


HDMICEC_HAL_LLAMA_VERSION = stable2
HDMICEC_HAL_LLAMA_SITE_METHOD = git
HDMICEC_HAL_LLAMA_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/hdmicec/soc/amlogic/common
HDMICEC_HAL_LLAMA_AUTORECONF = YES
HDMICEC_HAL_LLAMA_INSTALL_STAGING = YES
HDMICEC_HAL_LLAMA_DEPENDENCIES = hdmicec-header




define HDMICEC_HAL_LLAMA_INSTALL_TARGET_CMDS
    install -d $(TARGET_DIR)/usr/lib
    install -m 0644 $(@D)/libRCECHal.so    $(TARGET_DIR)/usr/lib
    install -d $(STAGING_DIR)/usr/lib
    install -m 0644 $(@D)/libRCECHal.so    $(STAGING_DIR)/usr/lib
endef



$(eval $(cmake-package))
