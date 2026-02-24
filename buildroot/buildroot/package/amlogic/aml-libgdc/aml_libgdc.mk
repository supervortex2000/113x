################################################################################
#
# libgdc
#
################################################################################

ifneq ($(BR2_PACKAGE_AML_LIBGDC_LOCAL_PATH),)

AML_LIBGDC_VERSION:= 1.0.0
AML_LIBGDC_SITE := $(call qstrip,$(BR2_PACKAGE_AML_LIBGDC_LOCAL_PATH))
AML_LIBGDC_SITE_METHOD:=local
AML_LIBGDC_DEPENDENCIES = aml-libion
AML_LIBGDC_INSTALL_STAGING:=YES

ifeq ($(BR2_aarch64), y)
AML_DEW_BIT := 64
else
AML_DEW_BIT := 32
endif

define AML_LIBGDC_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D)
    $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D) dewarp_test AML_DEW_BIT=$(AML_DEW_BIT)
endef

define AML_LIBGDC_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libgdc.so $(TARGET_DIR)/usr/lib/
    $(INSTALL) -D -m 0644 $(@D)/dewarp/lib/$(AML_DEW_BIT)/libdewarp.so $(TARGET_DIR)/usr/lib/
    $(INSTALL) -D -m 0755 $(@D)/gdc_test  $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0755 $(@D)/dewarp_test  $(TARGET_DIR)/usr/bin/
endef

define AML_LIBGDC_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libgdc.so \
        $(STAGING_DIR)/usr/lib/libgdc.so
    $(INSTALL) -D -m 0644 $(@D)/dewarp/lib/$(AML_DEW_BIT)/libdewarp.so \
        $(STAGING_DIR)/usr/lib/libdewarp.so
    $(INSTALL) -m 0644 $(@D)/include/gdc/gdc_api.h \
        $(STAGING_DIR)/usr/include/
    $(INSTALL) -m 0644 $(@D)/dewarp/dewarp_api.h \
        $(STAGING_DIR)/usr/include/
endef

define AML_LIBGDC_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

endif
$(eval $(generic-package))
