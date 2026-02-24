#
# lvgl-app
#
LVGL_APP_VERSION = 1.0.0
LVGL_APP_SITE = $(TOPDIR)/package/amlogic/lvgl-app
LVGL_APP_SITE_METHOD = local
LVGL_APP_INSTALL_STAGING = YES
LVGL_CORE_VERSION = 8.1.0
LV_DRIVERS_VERSION = 8.1.0
LV_DEMOS_VERSION = 8.1.0

LVGL_URL := https://github.com/lvgl/lvgl/archive/refs/tags/v$(LVGL_CORE_VERSION).tar.gz
LV_DRIVERS_URL := https://github.com/lvgl/lv_drivers/archive/refs/tags/v$(LV_DRIVERS_VERSION).tar.gz
LV_DEMOS_URL := https://github.com/lvgl/lv_demos/archive/refs/tags/v$(LV_DEMOS_VERSION).tar.gz

LVGL_FILE := lvgl-$(LVGL_CORE_VERSION).tar.gz
LV_DRIVERS_FILE := lv_drivers-$(LV_DRIVERS_VERSION).tar.gz
LV_DEMOS_FILE := lv_demos-$(LV_DEMOS_VERSION).tar.gz

#"lv_drv_conf_template.h" and "lv_conf_template.h" as template configure files, enable it by setting #if 0 to
# #if 1, and you must rename it to "lv_drv_conf.h" and "lv_conf.h".
define LVGL_APP_CONFIGURE_CMDS
    [ -r "${@D}/lvgl/lv_conf.h" ] \
        || sed -e 's|#if 0 .*Set it to "1" to enable .*|#if 1 // Enabled|g' \
        -e "s|\(#define LV_MEM_CUSTOM .*\)0|\1${LVGL_CONFIG_LV_MEM_CUSTOM}|g" \
            < "${@D}/lvgl/lv_conf_template.h" > "${@D}/lvgl/lv_conf.h"

    [ -r "${@D}/lv_drivers/lv_drv_conf.h" ] \
        || sed -e "s|#if 0 .*Set it to \"1\" to enable the content.*|#if 1 // Enabled by ${PN}|g" \
        -e "s|\(^ *# *define *WAYLAND_HOR_RES *\).*|\1${LVGL_CONFIG_WAYLAND_HOR_RES}|g" \
        -e "s|\(^ *# *define *WAYLAND_VER_RES *\).*|\1${LVGL_CONFIG_WAYLAND_VER_RES}|g" \
          < "${@D}/lv_drivers/lv_drv_conf_template.h" > "${@D}/lv_drivers/lv_drv_conf.h"
endef

define EXTRACT_LVGL
    [ ! -d $(@D)/lvgl ] && wget --no-check-certificate  $(LVGL_URL) -O $(@D)/$(LVGL_FILE)  && tar -xf $(@D)/$(LVGL_FILE) -C $(@D) && mv $(@D)/lvgl-$(LVGL_CORE_VERSION) $(@D)/lvgl
    [ ! -d $(@D)/lv_drivers ] && wget  --no-check-certificate  $(LV_DRIVERS_URL) -O $(@D)/$(LV_DRIVERS_FILE) && tar -xf $(@D)/$(LV_DRIVERS_FILE) -C $(@D) && mv $(@D)/lv_drivers-$(LV_DRIVERS_VERSION) $(@D)/lv_drivers
endef

ifeq ($(BR2_PACKAGE_LVGL_DEMOS),y)
define EXTRACT_LVGL_DEMOS
    [ ! -d $(@D)/lv_demos ] && wget --no-check-certificate  $(LV_DEMOS_URL) -O $(@D)/$(LV_DEMOS_FILE)  && tar -xf $(@D)/$(LV_DEMOS_FILE) -C $(@D) && mv $(@D)/lv_demos-$(LV_DEMOS_VERSION) $(@D)/lv_demos
endef
endif

LVGL_APP_PRE_PATCH_HOOKS += EXTRACT_LVGL
LVGL_APP_PRE_PATCH_HOOKS += EXTRACT_LVGL_DEMOS

export BR2_PACKAGE_LVGL_DEMOS
define LVGL_APP_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D) all
endef

define LVGL_APP_INSTALL_STAGING_CMDS
    mkdir -p $(STAGING_DIR)/usr/include/lvgl/lv_drivers
    $(INSTALL) -D -m 0644 $(@D)/lvgl/lvgl.h          $(STAGING_DIR)/usr/include/lvgl/
    $(INSTALL) -D -m 0644 $(@D)/lvgl/lv_conf.h       $(STAGING_DIR)/usr/include/lvgl/
    for ff in $$(find $(@D)/lvgl/src -type d); do \
        $$([ ! -d $(STAGING_DIR)/usr/include/lvgl/$$(echo $${ff#*lvgl/}) ] && \
        mkdir $(STAGING_DIR)/usr/include/lvgl/$$(echo $${ff#*lvgl/}) -p); \
        if [ "$$(ls $$ff/*.h 2> /dev/null | wc -l)" != "0" ]; then \
            $(INSTALL) -D -m 0644 $$ff/*.h $(STAGING_DIR)/usr/include/lvgl/$$(echo $${ff#*lvgl/}); \
        fi \
    done

    $(INSTALL) -D -m 0644 $(@D)/lv_drivers/lv_drv_conf.h  $(STAGING_DIR)/usr/include/lvgl/lv_drivers/
    $(INSTALL) -D -m 0644 $(@D)/lv_drivers/win_drv.h      $(STAGING_DIR)/usr/include/lvgl/lv_drivers/
    for ff in $$(find $(@D)/lv_drivers -type d); do \
        $$([ ! -d $(STAGING_DIR)/usr/include/lvgl/$$(echo $${ff#*lvgl-app-$(LVGL_APP_VERSION)/}) ] && \
        mkdir $(STAGING_DIR)/usr/include/lvgl/$$(echo $${ff#*lvgl-app-$(LVGL_APP_VERSION)/}) -p); \
        if [ "$$(ls $$ff/*.h 2> /dev/null | wc -l)" != "0" ]; then \
            $(INSTALL) -D -m 0644 $$ff/*.h $(STAGING_DIR)/usr/include/lvgl/lv_drivers/$$(echo $${ff#*lv_drivers/}); \
        fi \
    done

    $(INSTALL) -D -m 0644 $(@D)/liblvgl.a             $(STAGING_DIR)/usr/lib/
    $(INSTALL) -D -m 0644 $(@D)/liblv_drivers.a       $(STAGING_DIR)/usr/lib/
endef

define LVGL_APP_INSTALL_TARGET_CMDS
    $(INSTALL) -m 0755 $(@D)/lvgl-app $(TARGET_DIR)/usr/bin/
endef

define LVGL_APP_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) CXX=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
