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


HDMICEC_HEADER_VERSION = stable2
HDMICEC_HEADER_SITE_METHOD = git
HDMICEC_HEADER_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/hdmicec/generic
HDMICEC_HEADER_AUTORECONF = YES
HDMICEC_HEADER_INSTALL_STAGING = YES
#HDMICEC_HEADER_DEPENDENCIES =



define HDMICEC_HEADER_INSTALL_STAGING_CMDS
   install -d $(STAGING_DIR)/usr/include/ccec/drivers/iarmbus
   install -m 0644 $(@D)/ccec/drivers/include/ccec/drivers/*.h              $(STAGING_DIR)/usr/include/ccec/drivers
   install -m 0644 $(@D)/ccec/drivers/include/ccec/drivers/iarmbus/*.h              $(STAGING_DIR)/usr/include/ccec/drivers/

endef



$(eval $(generic-package))
