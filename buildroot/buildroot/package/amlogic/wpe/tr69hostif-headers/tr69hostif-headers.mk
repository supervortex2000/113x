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


TR69HOSTIF_HEADERS_VERSION = stable2
TR69HOSTIF_HEADERS_SITE_METHOD = git
TR69HOSTIF_HEADERS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/tr69hostif/generic
TR69HOSTIF_HEADERS_AUTORECONF = YES
#TR69HOSTIF_HEADERS_INSTALL_STAGING = YES
#TR69HOSTIF_HEADERS_DEPENDENCIES =



define TR69HOSTIF_HEADERS_INSTALL_TARGET_CMDS
   echo  $(STAGING_DIR)
   install -d $(STAGING_DIR)/usr/include
   install -m 0644 $(@D)/src/hostif/include/*.h            $(STAGING_DIR)/usr/include
   install -m 0644 $(@D)/src/hostif/handlers/include/*.h   $(STAGING_DIR)/usr/include

endef



$(eval $(generic-package))
