################################################################################
#
# aml bt driver
#
################################################################################

AML_BT_VERSION = 1.0.0
ifeq ($(call qstrip, $(BR2_PACKAGE_AML_BT_LOCAL_PATH)),)
BR2_PACKAGE_AML_BT_LOCAL_PATH = $(TOPDIR)/dummy
endif
AML_BT_MODULE_DIR = kernel/amlogic/bt
AML_BT_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(AML_BT_MODULE_DIR)

ifeq ($(BR2_PACKAGE_AML_BT),y)
AML_BT_SITE = $(call qstrip,$(BR2_PACKAGE_AML_BT_LOCAL_PATH))
AML_BT_SITE_METHOD = local
endif

AML_BT_SYSTEM_CONFIG_DIR = $(REALTEK_BT_PKGDIR)/.

AML_BT_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_AML_BT),y)
define AML_BT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D) ARCH=$(KERNEL_ARCH) \
		KBUILD_EXTRA_SYMBOLS=$(@D)/../aml-wifi-r-amlogic/project_w1/vmac/Module.symvers \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define AML_BT_INSTALL_TARGET_CMDS
	mkdir -p $(AML_BT_INSTALL_DIR)
	mkdir -p $(TARGET_DIR)/etc/bluetooth/aml
	$(INSTALL) -D -m 0644 $(@D)/aml_sdio.ko $(AML_BT_INSTALL_DIR)
	$(INSTALL) -D -m 0644 $(@D)/sdio_bt.ko $(AML_BT_INSTALL_DIR)
	echo $(AML_BT_MODULE_DIR)/sdio_bt.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	$(INSTALL) -D -m 0644 package/amlogic/aml-wifibt/aml-bt/aml_bt_rf.txt $(TARGET_DIR)/etc/bluetooth/aml
	$(INSTALL) -D -m 0644 package/amlogic/aml-wifibt/aml-bt/a2dp_mode_cfg.txt $(TARGET_DIR)/etc/bluetooth/aml
	$(INSTALL) -D -m 0644 package/amlogic/aml-wifibt/aml-bt/fw_file/w1_bt_fw_uart.bin $(TARGET_DIR)/etc/bluetooth/aml
	$(INSTALL) -D -m 0644 package/amlogic/aml-wifibt/aml-bt/fw_file/w1u_bt_fw_uart.bin $(TARGET_DIR)/etc/bluetooth/aml
endef
endif

$(eval $(generic-package))

include package/amlogic/aml-wifibt/aml-bt/*/*.mk
