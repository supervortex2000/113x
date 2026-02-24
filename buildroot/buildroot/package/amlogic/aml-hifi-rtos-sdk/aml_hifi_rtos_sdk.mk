#
# Copyright (c) 2014 Amlogic, Inc. All rights reserved.
# This source code is subject to the terms and conditions defined in the file 'LICENSE' which is part of this source code package.
# Description: mk file
#

BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH:= $(call qstrip,$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH))
ifneq ($(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH),)

AML_HIFI_RTOS_SDK_VERSION = 1.0.0
AML_HIFI_RTOS_SDK_SITE := $(call qstrip,$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH))
AML_HIFI_RTOS_SDK_SITE_METHOD = local
AML_HIFI_RTOS_SDK_SOC_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))
AML_HIFI_RTOS_SDK_PREBUILT = rtos-prebuilt-$(AML_HIFI_RTOS_SDK_SOC_NAME)
AML_HIFI_RTOS_SDK_DEPENDENCIES += aml-dsp-util

ifneq ($(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION),)
ARCH_HIFIA=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION)|awk '{print $$1}')
SOC_HIFIA=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION)|awk '{print $$2}')
BOARD_HIFIA=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION)|awk '{print $$3}')
PRODUCT_HIFIA=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION)|awk '{print $$4}')
endif

ifneq ($(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION),)
ARCH_HIFIB=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION) |awk '{print $$1}')
SOC_HIFIB=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION) |awk '{print $$2}')
BOARD_HIFIB=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION) |awk '{print $$3}')
PRODUCT_HIFIB=$(shell echo $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION) |awk '{print $$4}')
endif

AML_HIFI_RTOS_SDK_DEFAULT_MANIFEST_SRC=$(TOPDIR)/../.repo/manifests/buildroot_HiFiDSP_rtos_sdk.xml
AML_HIFI_RTOS_SDK_DEFAULT_MANIFEST_DST=$(@D)/products/hifi_dsp/rtos_sdk_manifest.xml

define AML_HIFI_RTOS_SDK_BUILD_CMDS
	mkdir -p $(BINARIES_DIR)
	if [ -f $(AML_HIFI_RTOS_SDK_DEFAULT_MANIFEST_SRC) ]; then \
		cp $(AML_HIFI_RTOS_SDK_DEFAULT_MANIFEST_SRC) $(AML_HIFI_RTOS_SDK_DEFAULT_MANIFEST_DST) -f; \
	else \
		echo "Error: Can't find the hifi-rtos-sdk manifest file!"; \
		echo "This will cause compilation to fail in a Non-repo environment!"; \
		false; \
	fi

	if [[ $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_BUILD_OPTION) != "" ]]; then \
		pushd $(@D);  \
		source scripts/env.sh $(ARCH_HIFIA) $(SOC_HIFIA) $(BOARD_HIFIA) $(PRODUCT_HIFIA); \
		set -e; \
		$(MAKE) all REPO_DIR=$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH); \
		if [ -d ./docs ]; then $(MAKE) docs REPO_DIR=$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH) ; else echo "No docs repo found. Do not generate docs"; fi ; \
		test -f ./output/$(ARCH_HIFIA)-$(BOARD_HIFIA)-$(PRODUCT_HIFIA)/freertos/freertos.bin &&  $(INSTALL) -D -m 644 ./output/$(ARCH_HIFIA)-$(BOARD_HIFIA)-$(PRODUCT_HIFIA)/freertos/freertos.bin $(BINARIES_DIR)/dspbootA.bin || true;\
		popd; \
	fi

	if [[ $(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_BUILD_OPTION) != "" ]]; then \
		pushd $(@D);  \
		source scripts/env.sh $(ARCH_HIFIB) $(SOC_HIFIB) $(BOARD_HIFIB) $(PRODUCT_HIFIB); \
		set -e; \
		$(MAKE) all REPO_DIR=$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_LOCAL_PATH); \
		test -f ./output/$(ARCH_HIFIB)-$(BOARD_HIFIB)-$(PRODUCT_HIFIB)/freertos/freertos.bin &&  $(INSTALL) -D -m 644 ./output/$(ARCH_HIFIB)-$(BOARD_HIFIB)-$(PRODUCT_HIFIB)/freertos/freertos.bin $(BINARIES_DIR)/dspbootB.bin || true;\
		popd; \
	fi
endef

define AML_HIFI_RTOS_SDK_INSTALL_TARGET_CMDS
	if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_INSTALL)" ]; then \
		mkdir -p $(TARGET_DIR)/lib/firmware/; \
		$(INSTALL) -D -m 644 $(BINARIES_DIR)/dspbootA*.bin $(TARGET_DIR)/lib/firmware/;\
		if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_AUTOLOAD)" ]; then \
			$(INSTALL) -D -m 755 \
			$(AML_HIFI_RTOS_SDK_PKGDIR)/S71_load_dspa \
			$(TARGET_DIR)/etc/init.d/;\
		fi \
	fi
	if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_INSTALL)" ]; then \
		mkdir -p $(TARGET_DIR)/lib/firmware/; \
		$(INSTALL) -D -m 644 $(BINARIES_DIR)/dspbootB*.bin $(TARGET_DIR)/lib/firmware/;\
		if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_AUTOLOAD)" ]; then \
			$(INSTALL) -D -m 755 \
			$(AML_HIFI_RTOS_SDK_PKGDIR)/S71_load_dspb \
			$(TARGET_DIR)/etc/init.d/;\
		fi \
	fi
	#Package RTOS build result
	pushd $(BINARIES_DIR); \
		mkdir -p $(AML_HIFI_RTOS_SDK_PREBUILT); \
		test -f rtos-uImage && cp -fv rtos-uImage $(AML_HIFI_RTOS_SDK_PREBUILT); \
		cp -f dspboot*.bin $(AML_HIFI_RTOS_SDK_PREBUILT)/ || true; \
		tar -zcf $(AML_HIFI_RTOS_SDK_PREBUILT).tgz -C $(AML_HIFI_RTOS_SDK_PREBUILT) ./; \
	popd
endef

endif

BR2_PACKAGE_AML_HIFI_RTOS_SDK_PREBUILT_PATH:= $(call qstrip,$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_PREBUILT_PATH))
ifneq ($(BR2_PACKAGE_AML_HIFI_RTOS_SDK_PREBUILT_PATH),)

AML_HIFI_RTOS_SDK_VERSION = 1.0.0
AML_HIFI_RTOS_SDK_SITE := $(call qstrip,$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_PREBUILT_PATH))
AML_HIFI_RTOS_SDK_SITE_METHOD = local
AML_HIFI_RTOS_SDK_DEPENDENCIES += aml-dsp-util

define AML_HIFI_RTOS_SDK_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)
	if [ -f $(@D)/rtos-uImage ]; then \
		$(INSTALL) -D -m 644 $(@D)/rtos-uImage $(BINARIES_DIR)/; \
	fi
	if [ -f $(@D)/dspbootA.bin ]; then \
		$(INSTALL) -D -m 644 $(@D)/dspbootA.bin $(BINARIES_DIR)/; \
	fi
	if [ -f $(@D)/dspbootB.bin ]; then \
		$(INSTALL) -D -m 644 $(@D)/dspbootB.bin $(BINARIES_DIR)/; \
	fi
	if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_INSTALL)" ]; then \
		mkdir -p $(TARGET_DIR)/lib/firmware/; \
		$(INSTALL) -D -m 644 $(@D)/dspbootA.bin $(TARGET_DIR)/lib/firmware/;\
		if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPA_AUTOLOAD)" ]; then \
			$(INSTALL) -D -m 755 \
			$(AML_HIFI_RTOS_SDK_PKGDIR)/S71_load_dspa \
			$(TARGET_DIR)/etc/init.d/;\
		fi \
	fi
	if [ -n "$(BR2_PACKAGE_AML_HIFI_RTOS_SDK_DSPB_INSTALL)" ]; then \
		mkdir -p $(TARGET_DIR)/lib/firmware/; \
		$(INSTALL) -D -m 644 $(@D)/dspbootB.bin $(TARGET_DIR)/lib/firmware/;\
		if [ -n "$(BR2_PACKAGE_AML_HIFI_RTO_SDKS_DSPB_AUTOLOAD)" ]; then \
			$(INSTALL) -D -m 755 \
			$(AML_HIFI_RTOS_SDK_PKGDIR)/S71_load_dspb \
			$(TARGET_DIR)/etc/init.d/;\
		fi \
	fi
endef

endif
$(eval $(generic-package))

