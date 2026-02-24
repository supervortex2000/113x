############################################################
#
# AML LIBJPEG TEST
#
#############################################################

AML_LIBJPEG_TEST_VERSION = 1.0
AML_LIBJPEG_TEST_SITE = $(TOPDIR)/package/amlogic/aml-libjpeg-test/src
AML_LIBJPEG_TEST_SITE_METHOD = local
AML_LIBJPEG_TEST_INSTALL_STAGING = NO

ifeq ($(BR2_PACKAGE_PROVIDES_JPEG), "libjpeg")
AML_LIBJPEG_TEST_DEPENDENCIES = libjpeg
TARGET_OUT = jpeg_test_nonturbo_v9d
else
AML_LIBJPEG_TEST_DEPENDENCIES = jpeg-turbo
TARGET_OUT = jpeg_test_turbo_v8
endif

define AML_LIBJPEG_TEST_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) OUTPUT=$(TARGET_OUT)
endef

define AML_LIBJPEG_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(TARGET_OUT) $(TARGET_DIR)/usr/bin/$(TARGET_OUT)
endef

$(eval $(generic-package))
