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


CIMPLOG_VERSION = 8cf7bec93c138c89aa172d4930826deb23a8a658
CIMPLOG_SITE_METHOD = git
CIMPLOG_SITE = git://github.com/Comcast/cimplog.git
CIMPLOG_AUTORECONF = YES
CIMPLOG_INSTALL_STAGING = YES
CIMPLOG_DEPENDENCIES = rdk-logger





CIMPLOG_CONF_OPTS += -DRDK_LOGGER=OFF -DBUILD_TESTING=OFF -DBUILD_YOCTO=false


#CIMPLOG_CONF_OPTS += LDFLAGS="$(TARGET_LDFLAGS) -lm "






define CIMPLOG_INSTALL_TARGET_CMDS



endef

#define FPDRIVERLIB_BUILD_CMDS

#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
#				CFLAGS="$(TARGET_CFLAGS)  $(INCLUDE_APPEND)"

#endef


$(eval $(cmake-package))
