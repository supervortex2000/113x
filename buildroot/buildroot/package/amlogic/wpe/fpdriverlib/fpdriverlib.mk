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


FPDRIVERLIB_VERSION = 1.1
FPDRIVERLIB_SOURCE = fpdriverlib-$(FPDRIVERLIB_VERSION).tar.gz
FPDRIVERLIB_SITE = https://partners.artifactory.comcast.com/artifactory/sky_llama/prebuilts/fpdriver/fpdriverlib/$(FPDRIVERLIB_VERSION)
#FPDRIVERLIB_INSTALL_STAGING = NO
#FPDRIVERLIB_INSTALL_TARGET = NO
#FPDRIVERLIB_DEPENDENCIES =






define FPDRIVERLIB_INSTALL_TARGET_CMDS

   install -d $(TARGET_DIR)/usr/lib
   install -d $(STAGING_DIR)/usr/lib
   install -d $(STAGING_DIR)/usr/include

   install -m 0755 $(@D)/*.so  $(TARGET_DIR)/usr/lib/
   install -m 0755 $(@D)/*.so  $(STAGING_DIR)/usr/lib/
   install -m 0755 $(@D)/*.h   $(STAGING_DIR)/usr/include



endef

#define FPDRIVERLIB_BUILD_CMDS

#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
#				CFLAGS="$(TARGET_CFLAGS)  $(INCLUDE_APPEND)"

#endef


$(eval $(generic-package))
