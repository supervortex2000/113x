################################################################################
#
# swupdate ui
#
################################################################################
AML_SWUPDATE_UI_VERSION:= 20220110
AML_SWUPDATE_UI_SITE:= $(TOPDIR)/../vendor/amlogic/aml_swupdate_ui
AML_SWUPDATE_UI_SITE_METHOD:=local
AML_SWUPDATE_UI_INSTALL_TARGET:=YES
AML_SWUPDATE_UI_DEPENDENCIES = swupdate

ifeq ($(BR2_PACKAGE_LVGL_APP),y)
    AML_SWUPDATE_UI_LVGL_SUP = CONFIG_LVGL_APP=y
    AML_SWUPDATE_UI_DEPENDENCIES += lvgl-app
else
    AML_SWUPDATE_UI_DEPENDENCIES += directfb
endif

define AML_SWUPDATE_UI_BUILD_CMDS
    $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" \
    PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
    "$(AML_SWUPDATE_UI_LVGL_SUP)" LD="$(TARGET_LD)" -C $(@D) all
endef

define AML_SWUPDATE_UI_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/swupdateui $(TARGET_DIR)/bin
endef

define AML_SWUPDATE_UI_PERMISSIONS
    /bin/swupdateui f 4755 0 0 - - - - -
endef

$(eval $(generic-package))
