#############################################################
#
# Dolby Audio for Wireless Speakers
#
#############################################################
DTS_RELEASE_VERSION:=1.0.0
DTS_RELEASE_SITE=$(TOPDIR)/../multimedia/dts_release
DTS_RELEASE_SITE_METHOD=local


ifeq ($(BR2_aarch64),y)
export ENABLE_DTS_64bit = yes
endif


define DTS_RELEASE_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D) all
endef

define DTS_RELEASE_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define DTS_RELEASE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install
endef

define DTS_RELEASE_UNINSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) uninstall
endef

$(eval $(generic-package))
