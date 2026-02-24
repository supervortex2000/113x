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


IARMMGRS_VERSION = stable2
IARMMGRS_SITE_METHOD = git
IARMMGRS_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/iarmmgrs/generic
#IARMMGRS_INSTALL_STAGING = YES
IARMMGRS_AUTORECONF = YES
IARMMGRS_DEPENDENCIES = iarmmgrs-hal-llama iarmbus hdmicec devicesettings rfc yajl wdmp-c libdrm aml_systemd libglib2


IARMGRS_INCLUDE_APPEND = \
    -I$(@D)/power/include \
    -I$(@D)/ir/include \
    -I$(@D)/mfr/include \
    -I$(@D)/sysmgr/include \
    -I$(STAGING_DIR)/usr/include/wdmp-c \
    -I$(STAGING_DIR)/usr/include/rdk/iarmbus \
    -I$(STAGING_DIR)/usr/include/rdk/servicemanager/helpers \
    -I$(STAGING_DIR)/usr/include/rdk/servicemanager \
    -I$(STAGING_DIR)/usr/include/ccec/drivers/iarmbus \
    -I$(STAGING_DIR)/usr/include/ccec/drivers/ \
    -I$(STAGING_DIR)/usr/include \
    -I$(STAGING_DIR)/usr/include/rdk/ds \
    -I$(STAGING_DIR)/usr/include/rdk/ds-hal \
    -I$(STAGING_DIR)/usr/include/rdk/ds-rpc \
    -I$(STAGING_DIR)/usr/include/rdk/iarmmgrs-hal \
    -I$(STAGING_DIR)/usr/include/directfb \
    -I$(STAGING_DIR)/usr/include/glib-2.0 \
    -I$(STAGING_DIR)/usr/lib/glib-2.0/include  \
    -I$(@D)/deviceUpdateMgr \
    -I$(@D)/deviceUpdateMgr/include \
    -I$(@D)/ipMgr/include \
    -I$(@D)/vrexmgr/include \
    -lIARMBus -lsystemd -lpthread -lglib-2.0 -ldl




IARMMGRS_CFLAGS := $(TARGET_CFLAGS)
IARMMGRS_CFLAGS += -lpthread -lglib-2.0 -L. -lIARMBus -ldl
IARMMGRS_CFLAGS += -fPIC -D_REENTRANT -Wall $(INCLUDE_DIRS)  $(INCLUDE_APPEND)
IARMMGRS_CFLAGS += -DRDK_DSHAL_NAME="\""libds-hal.so.0\"""
IARMMGRS_CFLAGS +=  -DBUILDROOT_BUILD  -lds-hal -DHAS_FLASH_PERSISTENT -DHAS_THERMAL_API  -lds-hal -DHAS_HDCP_CALLBACK





IARMMGRS_CONF_OPTS = CFLAGS="$(TARGET_CFLAGS) $(IARMGRS_INCLUDE_APPEND) "







define IARMMGRS_INSTALL_TARGET_CMDS

	for i in sysmgr power ir rdmmgr receiver; do\
		install -d $(STAGING_DIR)/usr/include/rdk/iarmmgrs/$$i && \
		install -m 0644 $(@D)/$$i/include/*.h $(STAGING_DIR)/usr/include/rdk/iarmmgrs/$$i  || exit 1; \
	done


	install -d $(TARGET_DIR)/usr/bin
	install -m 0755 $(@D)/sysmgr/sysMgrMain  $(TARGET_DIR)/usr/bin
	install -m 0755 $(@D)/power/pwrMgrMain  $(TARGET_DIR)/usr/bin
	install -m 0755 $(@D)/ir/irMgrMain   $(TARGET_DIR)/usr/bin
	install -m 0755 $(@D)/dsmgr/dsMgrMain  $(TARGET_DIR)/usr/bin

	install -d $(TARGET_DIR)/usr/lib
	install -m 0755 $(@D)/./ir/libuinput.so  $(TARGET_DIR)/usr/lib

endef


define IARMMGRS_REMOVE_MAKEFILE

endef

define IARMMGRS_BUILD_CMDS


	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/sysmgr/ $(TARGET_CONFIGURE_OPTS) \
				CFLAGS="$(TARGET_CFLAGS) -fPIC $(IARMGRS_INCLUDE_APPEND) -DENABLE_SD_NOTIFY"



	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/dsmgr/ $(TARGET_CONFIGURE_OPTS) \
				CFLAGS="$(TARGET_CFLAGS) -fPIC $(IARMGRS_INCLUDE_APPEND) "\
				LDFLAGS="$(TARGET_LDFLAGS) -lds-hal -ldshalsrv -ldl -lIARMBus "



	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/ir/ $(TARGET_CONFIGURE_OPTS) \
				CFLAGS="$(TARGET_CFLAGS) -fPIC $(IARMGRS_INCLUDE_APPEND) "\
			LDFLAGS="$(TARGET_LDFLAGS) -liarmmgrs-ir-hal -ldshalcli -lds -lrfcapi -lIARMBus  "



	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/power/ $(TARGET_CONFIGURE_OPTS) \
				CFLAGS="$(TARGET_CFLAGS) -fPIC $(IARMGRS_INCLUDE_APPEND) "\
				LDFLAGS="$(TARGET_LDFLAGS) -ldshalcli -lds -liarmmgrs-power-hal -lrfcapi -lIARMBus  "




endef


$(eval $(generic-package))

