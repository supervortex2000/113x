AML_COMMONLIB_VERSION=1.0
AML_COMMONLIB_SITE_METHOD=local
AML_COMMONLIB_SITE=$(TOPDIR)/../vendor/amlogic/aml_commonlib
AML_COMMONLIB_PACKAGE=$(TOPDIR)/package/amlogic/aml-commonlib

ifeq ($(BR2_PACKAGE_AML_LOG),y)
define AML_LOG_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)/aml_log all
endef
define AML_LOG_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/aml_log install
endef
endif

ifeq ($(BR2_PACKAGE_AML_SOCKETIPC),y)
define AML_SOCKETIPC_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)/aml_socketipc all
endef
define AML_SOCKETIPC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/aml_socketipc install
endef
endif

ifeq ($(BR2_PACKAGE_AML_AUDIO_CLOCK_SYNC),y)

define AML_AUDIO_CLOCK_SYNC_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)/aml_audio_clock_sync all
	$(INSTALL) -m 755 -D $(@D)/aml_audio_clock_sync/aml_audio_clock_sync $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(@D)/aml_audio_clock_sync/S99aml_audio_clock_sync $(TARGET_DIR)/etc/init.d/
endef

define AML_AUDIO_CLOCK_INSTALL_CLEAN_CMDS
	rm $(TARGET_DIR)/usr/bin/aml_audio_clock_sync
endef
endif

define AML_COMMONLIB_BUILD_CMDS
	$(AML_LOG_BUILD_CMDS)
	$(AML_SOCKETIPC_BUILD_CMDS)
	$(AML_AUDIO_CLOCK_SYNC_BUILD_CMDS)
endef

define AML_COMMONLIB_INSTALL_TARGET_CMDS
	$(AML_LOG_INSTALL_TARGET_CMDS)
	$(AML_SOCKETIPC_INSTALL_TARGET_CMDS)
	$(INSTALL) -m 644 -D $(@D)/socketipc/socketipc.h $(STAGING_DIR)/usr/include/
endef

define AML_COMMONLIB_INSTALL_CLEAN_CMDS
	$(AML_AUDIO_CLOCK_SYNC_INSTALL_CLEAN_CMDS)
endef

$(eval $(generic-package))
