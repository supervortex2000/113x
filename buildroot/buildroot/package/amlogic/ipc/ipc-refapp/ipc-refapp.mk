############################################################
#
# IPC REFAPP
#
#############################################################

IPC_REFAPP_VERSION = 1.0
IPC_REFAPP_SITE = $(TOPDIR)/../vendor/amlogic/ipc/ipc-refapp
IPC_REFAPP_SITE_METHOD = local
IPC_REFAPP_INSTALL_STAGING = NO
IPC_REFAPP_DEPENDENCIES = host-pkgconf
IPC_REFAPP_DEPENDENCIES += ipc-property ipc-sdk ipc-webstream-server ipc-rtsp-server ipc-mp4muxer
IPC_REFAPP_DEPENDENCIES += sqlite libjpeg
IPC_REFAPP_DEPENDENCIES += aml-nn-detect
IPC_REFAPP_DEPENDENCIES += ipc-ircut-module

IPC_REFAPP_GIT_VERSION=$(shell \
			if [ -d $(IPC_REFAPP_SITE)/.git ]; then \
			   git -C $(IPC_REFAPP_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_REFAPP_BUILD_CMDS
	REVISION=$(IPC_REFAPP_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_REFAPP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/ipc
	$(INSTALL) -D -m 755 $(@D)/ipc-refapp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/startup.sh $(TARGET_DIR)/etc/init.d/S81ipc-refapp
	$(INSTALL) -D -m 644 $(@D)/config.json $(TARGET_DIR)/etc/ipc/
	$(INSTALL) -D -m 755 $(@D)/ircut-gpio-detect.sh $(TARGET_DIR)/etc/ipc/
endef

$(eval $(generic-package))
