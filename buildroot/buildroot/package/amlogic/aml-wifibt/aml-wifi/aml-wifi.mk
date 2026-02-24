################################################################################
#
# amlogic aml_wifi driver
#
################################################################################

AML_WIFI_VERSION = $(call qstrip,$(BR2_PACKAGE_AML_WIFI_GIT_VERSION))
AML_WIFI_SITE = $(call qstrip,$(BR2_PACKAGE_AML_WIFI_GIT_REPO_URL))
AML_WIFI_MODULE_DIR = kernel/amlogic/wifi
AML_WIFI_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(AML_WIFI_MODULE_DIR)

ifeq ($(BR2_PACKAGE_AML_WIFI_LOCAL),y)
AML_WIFI_SITE = $(call qstrip,$(BR2_PACKAGE_AML_WIFI_LOCAL_PATH))
AML_WIFI_SITE_METHOD = local
endif

ifeq ($(BR2_PACKAGE_AML_WIFI_STANDALONE),y)
AML_WIFI_DEPENDENCIES = linux
endif

ifeq ($(BR2_PACKAGE_AML_WIFI),y)
define W1_BUILD_CMDS
	perl $(@D)/w1/project_w1/vmac/create_version_file.pl
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/w1/project_w1/vmac ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules CONFIG_BUILDROOT=y
	$(TARGET_KERNEL_CROSS)strip --strip-unneeded ${@D}/w1/project_w1/vmac/vlsicomm.ko
endef
define W1_BUILD_INSTALL_TARGET_CMDS
	mkdir -p $(AML_WIFI_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/w1/project_w1/vmac/vlsicomm.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/vlsicomm.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	$(INSTALL) -m 0666 $(@D)/w1/project_w1/vmac/aml_sdio.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/aml_sdio.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	mkdir -p $(TARGET_DIR)/etc/wifi/w1/
	mkdir -p $(TARGET_DIR)/lib/firmware/
	$(INSTALL) -m 0644 $(@D)/w1/project_w1/vmac/aml_wifi_rf*.txt $(TARGET_DIR)/etc/wifi/w1/
	$(INSTALL) -m 0644 $(@D)/w1/project_w1/vmac/aml_wifi_rf*.txt $(TARGET_DIR)/lib/firmware/
endef
endif

ifeq ($(BR2_PACKAGE_AML_WIFI_W1U),y)
define W1U_BUILD_CMDS
	perl $(@D)/w1u/project_w1u/vmac/create_version_file.pl
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/w1u/project_w1u/vmac ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules CONFIG_BUILDROOT=y
	$(TARGET_KERNEL_CROSS)strip --strip-unneeded ${@D}/w1u/project_w1u/vmac/w1u.ko
endef
define W1U_BUILD_INSTALL_TARGET_CMDS
	mkdir -p $(AML_WIFI_INSTALL_DIR)
	mkdir -p $(TARGET_DIR)/lib/firmware/w1u/
	$(INSTALL) -m 0666 $(@D)/w1u/project_w1u/vmac/w1u.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/w1u.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	$(INSTALL) -m 0666 $(@D)/w1u/project_w1u/vmac/w1u_comm.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/w1u_comm.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	mkdir -p $(TARGET_DIR)/etc/wifi/w1u/
	$(INSTALL) -m 0644 $(@D)/w1u/project_w1u/vmac/aml_wifi_rf*.txt $(TARGET_DIR)/lib/firmware/w1u/
	$(INSTALL) -m 0644 $(@D)/w1u/project_w1u/vmac/*.bin $(TARGET_DIR)/lib/firmware/
endef
endif

ifeq ($(BR2_PACKAGE_AML_WIFI_W2),y)
define W2_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/w2/aml_drv KERNELDIR=$(LINUX_DIR) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) CONFIG_BUILDROOT=y modules
	$(TARGET_KERNEL_CROSS)strip --strip-unneeded ${@D}/w2/aml_drv/fullmac/w2_comm.ko
	$(TARGET_KERNEL_CROSS)strip --strip-unneeded ${@D}/w2/aml_drv/fullmac/w2.ko
endef
define W2_BUILD_INSTALL_TARGET_CMDS
	mkdir -p $(AML_WIFI_INSTALL_DIR)
	mkdir -p $(TARGET_DIR)/lib/firmware/
	$(INSTALL) -m 0666 $(@D)/w2/aml_drv/fullmac/w2_comm.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/w2_comm.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	$(INSTALL) -m 0666 $(@D)/w2/aml_drv/fullmac/w2.ko $(AML_WIFI_INSTALL_DIR)
	echo $(AML_WIFI_MODULE_DIR)/w2.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	$(INSTALL) -m 0644 $(@D)/w2/common/*.txt $(TARGET_DIR)/lib/firmware/
	$(INSTALL) -m 0644 $(@D)/w2/common/*.bin $(TARGET_DIR)/lib/firmware/
endef
endif

define AML_WIFI_BUILD_CMDS
	$(W1_BUILD_CMDS)
	$(W1U_BUILD_CMDS)
	$(W2_BUILD_CMDS)
endef

define AML_WIFI_INSTALL_TARGET_CMDS
	$(W1_BUILD_INSTALL_TARGET_CMDS)
	$(W1U_BUILD_INSTALL_TARGET_CMDS)
	$(W2_BUILD_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
