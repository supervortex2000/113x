#############################################################
#
# TDK driver
#
#############################################################
TDK_VERSION = $(call qstrip,$(BR2_PACKAGE_TDK_GIT_VERSION))
ifneq ($(BR2_PACKAGE_TDK_GIT_REPO_URL),"")
TDK_SITE = $(call qstrip,$(BR2_PACKAGE_TDK_GIT_REPO_URL))
TDK_SITE_METHOD = git
else
 ifneq ($(BR2_PACKAGE_TDK_LOCAL_PATH),"")
 TDK_SITE = $(call qstrip,$(BR2_PACKAGE_TDK_LOCAL_PATH))
 else
 TDK_SITE = $(TOPDIR)/../vendor/amlogic/tdk
 endif
 TDK_SITE_METHOD = local
 TDK_VERSION = $(call qstrip,$(BR2_PACKAGE_TDK_VERSION))
endif
TDK_INSTALL_STAGING = YES
TDK_DEPENDENCIES = linux host-python-pycrypto tdk-driver

ifeq ($(BR2_aarch64), y)
_ARCH = arm64
_CROSS_COMPILE = aarch64-linux-gnu-
else
_ARCH = arm
_CROSS_COMPILE = arm-linux-gnueabihf-
endif

SECUROS_IMAGE_DIR = "gx"

ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "axg")
SECUROS_IMAGE_DIR = "axg"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "txlx")
SECUROS_IMAGE_DIR = "txlx"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "g12a")
SECUROS_IMAGE_DIR = "g12a"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "g12b")
SECUROS_IMAGE_DIR = "g12a"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "sm1")
SECUROS_IMAGE_DIR = "g12a"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "tl1")
SECUROS_IMAGE_DIR = "tl1"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "tm2")
SECUROS_IMAGE_DIR = "tm2"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "a1")
SECUROS_IMAGE_DIR = "a1"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "c1")
SECUROS_IMAGE_DIR = "c1"
else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "c2")
SECUROS_IMAGE_DIR = "c2"
#No need to call TDK_SECUROS_SIGN, uboot build already sign
#else ifeq ($(BR2_TARGET_UBOOT_PLATFORM), "sc2")
#SECUROS_IMAGE_DIR = "sc2"
else
SECUROS_IMAGE_DIR = "gx"
endif

ifeq ($(BR2_PACKAGE_TDK_VERSION),"3.8")
	ifeq ($(filter "A311D2" "POP1" "S905C2" "S905X4" "S905Y4" "S805X2" "S805X2G" "S905C3" "T963D4" "T965D4" "T982", $(BR2_PACKAGE_AML_SOC_CHIP_NAME)),)
		TA_PATH = v$(BR2_PACKAGE_TDK_VERSION)
	else
		TA_PATH = v$(BR2_PACKAGE_TDK_VERSION)/dev/$(BR2_PACKAGE_AML_SOC_CHIP_NAME)
	endif
else
	TA_PATH = v$(BR2_PACKAGE_TDK_VERSION)
endif

ifeq ($(BR2_aarch64), y)
define TDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm64/include/*.h $(STAGING_DIR)/usr/include
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm64/lib/* $(STAGING_DIR)/usr/lib/
endef
define TDK_INSTALL_LIBS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm64/lib/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm64/lib/*.so.* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/ca_export_arm64/bin/tee-supplicant $(TARGET_DIR)/usr/bin/
endef
else
ifeq ($(GCC_TARGET_FLOAT_ABI), softfp)
define TDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/include/*.h $(STAGING_DIR)/usr/include
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib_softfp/* $(STAGING_DIR)/usr/lib/
endef
define TDK_INSTALL_LIBS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib_softfp/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib_softfp/*.so.* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/ca_export_arm/bin_softfp/tee-supplicant $(TARGET_DIR)/usr/bin/
endef
else
define TDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/include/*.h $(STAGING_DIR)/usr/include
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib/* $(STAGING_DIR)/usr/lib/
endef
define TDK_INSTALL_LIBS
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/ca_export_arm/lib/*.so.* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0755 $(@D)/ca_export_arm/bin/tee-supplicant $(TARGET_DIR)/usr/bin/
endef
endif
endif
define TDK_INSTALL_TARGET_CMDS
	$(TDK_INSTALL_LIBS)
	cd $(@D); find . -name *_32 | xargs -i $(INSTALL) -m 0755 {} $(TARGET_DIR)/usr/bin
	cd $(@D); find . -name *_64 | xargs -i $(INSTALL) -m 0755 {} $(TARGET_DIR)/usr/bin

	mkdir -p $(TARGET_DIR)/lib/teetz/
	cd $(@D); find . -name *.ta | xargs -i $(INSTALL) -m 0644 {} $(TARGET_DIR)/lib/teetz

	install -m 755 $(TDK_PKGDIR)/S49optee $(TARGET_DIR)/etc/init.d/S49optee
	$(TDK_TA_TO_TARGET)
endef

$(eval $(generic-package))
