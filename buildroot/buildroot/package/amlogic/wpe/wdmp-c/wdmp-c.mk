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


WDMP_C_VERSION = 796dddbcfa7686ec63536d950775e79b52ee5c3f
WDMP_C_SITE_METHOD = git
WDMP_C_SITE = git://github.com/Comcast/wdmp-c.git
WDMP_C_AUTORECONF = YES
WDMP_C_INSTALL_STAGING=YES
#WDMP_C_INSTALL_TARGET=NO
WDMP_C_DEPENDENCIES = cjson cimplog host-pkgconf








 
WDMP_C_CONF_OPTS += -DBUILD_TESTING=OFF -DBUILD_YOCTO=NO 
	
WDMP_C_CFLGAS="$(TARGET_CFLAGS)  -I$(STAGING_DIR)/usr/include/cjson"


WDMP_C_CONF_OPTS += \
	-DCMAKE_C_FLAGS=$(WDMP_C_CFLGAS) 








define WDMP_C_INSTALL_TARGET_CMDS

    install -d $(STAGING_DIR)/usr/include

    install -m 0755 $(@D)/src/wdmp-c.h  $(STAGING_DIR)/usr/include


endef 


$(eval $(cmake-package))
