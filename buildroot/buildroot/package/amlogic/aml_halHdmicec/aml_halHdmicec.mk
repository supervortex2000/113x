################################################################################
#
# hdmi cec hal
#
################################################################################

AML_HALHDMICEC_VERSION = 1.0.0
AML_HALHDMICEC_SITE = $(TOPDIR)/../vendor/amlogic/aml_halHdmicec
AML_HALHDMICEC_SITE_METHOD = local
AML_HALHDMICEC_INSTALL_STAGING = YES
AML_HALHDMICEC_AUTORECONF = YES

AML_HALHDMICEC_INSTALL_STAGING_OPTS = \
    prefix=$(STAGING_DIR)/usr \
    exec_prefix=$(STAGING_DIR)/usr \
    PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib \
    install

AML_HALHDMICEC_INSTALL_TARGET_OPTS = \
    prefix=$(TARGET_DIR)/usr \
    exec_prefix=$(TARGET_DIR)/usr \
    install

define AML_HALHDMICEC_LIB_INSTALL_CMD
	$(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/lib/libhdmi_cec.default.so $(TARGET_DIR)/usr/lib/hdmi_cec.default.so
        rm -rf  $(TARGET_DIR)/usr/lib/libhdmi_cec.default.la
        rm -rf  $(TARGET_DIR)/usr/lib/libhdmi_cec.la
        rm -rf  $(TARGET_DIR)/usr/lib/libutils.la
endef

AML_HALHDMICEC_POST_INSTALL_TARGET_HOOKS += AML_HALHDMICEC_LIB_INSTALL_CMD
$(eval $(autotools-package))
