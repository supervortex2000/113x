#
# Copyright (c) 2014 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined in the file 'LICENSE' which is part of this source code package.
# Description: mk file
#

BR2_PACKAGE_AML_ARM_RTOS_SDK_LOCAL_PATH:= $(call qstrip,$(BR2_PACKAGE_AML_ARM_RTOS_SDK_LOCAL_PATH))
ifneq ($(BR2_PACKAGE_AML_ARM_RTOS_SDK_LOCAL_PATH),)

AML_ARM_RTOS_SDK_VERSION = 1.0.0
AML_ARM_RTOS_SDK_SITE := $(call qstrip,$(BR2_PACKAGE_AML_ARM_RTOS_SDK_LOCAL_PATH))
AML_ARM_RTOS_SDK_SITE_METHOD = local
AML_ARM_RTOS_SDK_SOC_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))
AML_ARM_RTOS_SDK_PREBUILT = rtos-prebuilt-$(AML_ARM_RTOS_SDK_SOC_NAME)

ifneq ($(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION),)
ARCH_ARM=$(shell echo $(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION)|awk '{print $$1}')
SOC_ARM=$(shell echo $(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION)|awk '{print $$2}')
BOARD_ARM=$(shell echo $(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION)|awk '{print $$3}')
PRODUCT_ARM=$(shell echo $(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION)|awk '{print $$4}')
endif

#$(MAKE) all REPO_DIR=$(BR2_PACKAGE_AML_ARM_RTOS_SDK_LOCAL_PATH); \

MKIMAGE=$HOST_DIR/bin/mkimage

AML_ARM_RTOS_SDK_DEPENDENCIES = uboot
UBOOT_VERSION=$(shell echo $(BR2_TARGET_UBOOT_CUSTOM_LOCAL_VERSION_VALUE)|awk '{print $$1}')
RTOS_EXTERN_SDK_XML = $(TOPDIR)/../.repo/manifests/buildroot_doorbell_fastboot_rtos_sdk.xml
export RTOS_EXTERN_SDK_XML

define AML_ARM_RTOS_SDK_BUILD_CMDS
	mkdir -p $(BINARIES_DIR)

	if [[ $(BR2_PACKAGE_AML_ARM_RTOS_SDK_BUILD_OPTION) != "" ]]; then \
		export RTOS_EXTERN_SDK_XML=$(@D)/products/fastboot/c3_doorbell_manifest.xml; \
		pushd $(@D); \
		./scripts/c3_fastboot.sh $(@D)/bl22 $(@D)/../uboot-$(UBOOT_VERSION) $(BOARD_ARM)\
		$(INSTALL) -D -m 644 $(@D)/../uboot-$(UBOOT_VERSION)/build/* $(BINARIES_DIR)/; \
		$(INSTALL) -D -m 644 $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/* $(BINARIES_DIR)/; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/bb1st.sto.fastboot.bin.signed $(BINARIES_DIR)/bb1st.sto.bin.signed; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/blob-bl2e.sto.fastboot.bin.signed $(BINARIES_DIR)/blob-bl2e.sto.bin.signed; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/blob-bl2x.fastboot.bin.signed $(BINARIES_DIR)/blob-bl2x.bin.signed; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/bb1st.usb.fastboot.bin.signed $(BINARIES_DIR)/bb1st.usb.bin.signed; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/blob-bl2e.usb.fastboot.bin.signed $(BINARIES_DIR)/blob-bl2e.usb.bin.signed; \
		cp $(@D)/../uboot-$(UBOOT_VERSION)/fip/_tmp/blob-bl31.fastboot.bin.signed $(BINARIES_DIR)/blob-bl31.bin.signed; \
		popd; \
	fi
endef

define AML_ARM_RTOS_SDK_INSTALL_TARGET_CMDS
	#Package RTOS build result
	pushd $(BINARIES_DIR); \
		mkdir -p $(AML_ARM_RTOS_SDK_PREBUILT); \
		test -f rtos-uImage && cp -fv rtos-uImage $(AML_ARM_RTOS_SDK_PREBUILT); \
		tar -zcf $(AML_ARM_RTOS_SDK_PREBUILT).tgz -C $(AML_ARM_RTOS_SDK_PREBUILT) ./; \
	popd
endef

endif

BR2_PACKAGE_AML_ARM_RTOS_SDK_PREBUILT_PATH:= $(call qstrip,$(BR2_PACKAGE_AML_ARM_RTOS_SDK_PREBUILT_PATH))
ifneq ($(BR2_PACKAGE_AML_ARM_RTOS_SDK_PREBUILT_PATH),)

AML_ARM_RTOS_SDK_VERSION = 1.0.0
AML_ARM_RTOS_SDK_SITE := $(call qstrip,$(BR2_PACKAGE_AML_ARM_RTOS_SDK_PREBUILT_PATH))
AML_ARM_RTOS_SDK_SITE_METHOD = local

define AML_ARM_RTOS_SDK_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)
	if [ -f $(@D)/rtos-uImage ]; then \
		$(INSTALL) -D -m 644 $(@D)/rtos-uImage $(BINARIES_DIR)/; \
	fi
endef

endif
$(eval $(generic-package))

