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


RFC_VERSION = stable2
RFC_SITE_METHOD = git
RFC_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/rfc/generic
RFC_AUTORECONF = YES
RFC_DEPENDENCIES =  iarmbus tr69hostif-headers wdmp-c  libcurl
RFC_INCLUDE_DIRS_APPEND =  \
    -I$(STAGING_DIR)/usr/include \
    -I$(STAGING_DIR)/usr/include/glib-2.0 \
    -I$(STAGING_DIR)/usr/include/directfb \
    -I$(STAGING_DIR)/usr/include/glib-2.0/include \
    -I$(STAGING_DIR)/usr/include/logger \
    -I$(STAGING_DIR)/usr/include/rdk/iarmbus

RFC_CONF_OPTS = \
		--includedir="$(STAGING_DIR)"  \
		CPPFLAGS="$(RFC_INCLUDE_DIRS_APPEND)" \
		cjson_CFLAGS="-I$(STAGING_DIR)/usr/include/cjson" \
		cjson_LIBS="-lcjson"
RFC_CONF_OPTS += --enable-rfctool=yes   --enable-tr181set=yes





define RFC_INSTALL_TARGET_CMDS

        install -d $(STAGING_DIR)/usr/include
	install -m 0644 $(@D)/rfcapi/rfcapi.h  $(STAGING_DIR)/usr/include
	install -d $(TARGET_DIR)/usr/lib/
	install -d $(STAGING_DIR)/usr/lib/

	install -m  0755 $(@D)/rfcapi/.libs/librfcapi.so*  $(STAGING_DIR)/usr/lib
	install -m  0755 $(@D)/rfcapi/.libs/librfcapi.so*  $(TARGET_DIR)/usr/lib

	install -m  0755 $(@D)/tr181api/.libs/libtr181api.so*  $(STAGING_DIR)/usr/lib
	install -m  0755 $(@D)/tr181api/.libs/libtr181api.so*  $(TARGET_DIR)/usr/lib

        #install -m 0755 $(@D)/RFCbase.sh $(TARGET_DIR)/usr/lib/rdk
        #install -m 0755 $(@D)/rfcInit.sh $(TARGET_DIR)/usr/lib/rdk
        #install -m 0755 $(@D)/RFCpostprocess.sh $(TARGET_DIR)/usr/lib/rdk
        #install -m 0644 $(@D)/rfc.properties $(TARGET_DIR)/usr/lib/rdk
	#install -m 0755 $(@D)/RFC_Reboot.sh $(TARGET_DIR)/usr/bin/RFC_Reboot.sh

endef

$(eval $(autotools-package))
