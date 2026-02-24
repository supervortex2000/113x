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


IARMBUS_VERSION = 323b76a5fa5866a35548eed1b9054dc68e857490
IARMBUS_SITE_METHOD = git
IARMBUS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/iarmbus/generic
IARMBUS_AUTORECONF = YES
IARMBUS_DEPENDENCIES = libxml2 dbus libglib2 libplayer




define IARMBUS_INSTALL_TARGET_CMDS
	install -d $(STAGING_DIR)/usr/include/rdk/iarmbus
	install -m 0644 $(@D)/core/include/*.h $(STAGING_DIR)/usr/include/rdk/iarmbus
	install -m 0644 $(@D)/core/*.h $(STAGING_DIR)/usr/include/rdk/iarmbus

	install -d $(TARGET_DIR)/usr/lib
	install -m 0755 $(@D)/core/.libs/libIARMBus.so*  $(TARGET_DIR)/usr/lib
	install -d $(STAGING_DIR)/usr/lib
	install -m 0755 $(@D)/core/.libs/libIARMBus.so*  $(STAGING_DIR)/usr/lib

	install -d $(TARGET_DIR)/usr/bin
	install -m 0755 $(@D)/core/IARMDaemonMain  $(TARGET_DIR)/usr/bin
endef

$(eval $(autotools-package))
