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
RDK_LOGGER_VERSION = stable2
RDK_LOGGER_SITE_METHOD = git
RDK_LOGGER_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/rdk_logger/generic
RDK_LOGGER_INSTALL_STAGING=YES
RDK_LOGGER_AUTORECONF = YES
RDK_LOGGER_DEPENDENCIES = log4c





RDK_CONF_OPTS += --enable-milestone



define RDK_LOGGER_INSTALL_TARGET_CMDS

	install -d $(TARGET_DIR)/usr/lib/
	install -m  0755 $(@D)/src/.libs/librdkloggers.so*  $(TARGET_DIR)/usr/lib


endef 

#define FPDRIVERLIB_BUILD_CMDS

#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) \
#				CFLAGS="$(TARGET_CFLAGS)  $(INCLUDE_APPEND)" 

#endef



$(eval $(autotools-package))
