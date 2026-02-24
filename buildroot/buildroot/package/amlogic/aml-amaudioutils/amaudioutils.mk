#############################################################
#
# aml_amaudioutils
#
#############################################################
AML_AMAUDIOUTILS_VERSION:=0.1
AML_AMAUDIOUTILS_SITE=$(TOPDIR)/../multimedia/aml_amaudioutils
AML_AMAUDIOUTILS_SITE_METHOD=local
AML_AMAUDIOUTILS_DEPENDENCIES=boost liblog aml-commonlib
export AML_AMAUDIOUTILS_BUILD_DIR = $(BUILD_DIR)
export AML_AMAUDIOUTILS_STAGING_DIR = $(STAGING_DIR)
export AML_AMAUDIOUTILS_TARGET_DIR = $(TARGET_DIR)
export AML_AMAUDIOUTILS_BR2_ARCH = $(BR2_ARCH)

#64bit toolchain did not support mfpu=neon
ifeq ($(BR2_ARCH),"aarch64")
	NEON_SUPPORT="TOOLCHAIN_NEON_SUPPORT=n"
endif

define AML_AMAUDIOUTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) $(NEON_SUPPORT) -C $(@D) all
	$(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) $(NEON_SUPPORT) -C $(@D) install
endef

$(eval $(generic-package))
