################################################################################
#
# amlogic mt7661 driver
#
################################################################################

MTK7661_VERSION = $(call qstrip,$(BR2_PACKAGE_MTK7661_GIT_VERSION))
MTK7661_SITE = $(call qstrip,$(BR2_PACKAGE_MTK7661_GIT_REPO_URL))
MTK7661_MODULE_DIR = kernel/mtk/wifi
MTK7661_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(MTK7661_MODULE_DIR)

ifeq ($(BR2_PACKAGE_MTK7661_LOCAL),y)
MTK7661_SITE = $(call qstrip,$(BR2_PACKAGE_MTK7661_LOCAL_PATH))
MTK7661_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_MTK7661_STANDALONE),y)
MTK7661_DEPENDENCIES = linux
endif

ifeq ($(BR2_PACKAGE_MTK7661_STANDALONE),y)
define MTK7661_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/wlan_driver/gen4m ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules;
endef
define MTK7661_INSTALL_TARGET_CMDS
	mkdir -p $(MTK7661_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/wlan_driver/gen4m/wlan_mt7663_sdio.ko $(MTK7661_INSTALL_DIR)
	echo $(MTK7661_MODULE_DIR)/wlan_mt7663_sdio.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	#install fw
	$(INSTALL) -D -m 0644 $(@D)/7661_firmware/* $(TARGET_DIR)/lib/firmware
endef
else

define MTK7661_BUILD_CMDS
    mkdir -p $(LINUX_DIR)/../hardware/wifi/mtk/drivers;
	ln -sf $(MTK7661_DIR) $(LINUX_DIR)/../hardware/wifi/mtk/drivers/mt7661;
endef
endif
$(eval $(generic-package))
