################################################################################
#
# Sraf_Browser
#
################################################################################
SRAF_BROWSER_SDK_VERSION = 20211204
SRAF_BROWSER_SDK_SITE = $(TOPDIR)/../vendor/amlogic/sraf-browser-sdk
SRAF_BROWSER_SDK_SITE_METHOD = local

define  SRAF_BROWSER_SDK_INSTALL_TARGET_CMDS
        mkdir -p $(TARGET_DIR)/3rd
	cp -rf $(@D)/sraf $(TARGET_DIR)/3rd/
endef

$(eval $(generic-package))
