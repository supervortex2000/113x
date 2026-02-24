################################################################################
#
# amlogic 8723DU driver
#
################################################################################

RTK8723DU_VERSION = $(call qstrip,$(BR2_PACKAGE_RTK8723DU_GIT_VERSION))
RTK8723DU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8723DU_GIT_REPO_URL))
RTK8723DU_MODULE_DIR = kernel/realtek/wifi
RTK8723DU_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(RTK8723DU_MODULE_DIR)

ifeq ($(BR2_PACKAGE_RTK8723DU_LOCAL),y)
RTK8723DU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8723DU_LOCAL_PATH))
RTK8723DU_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_RTK8723DU_STANDALONE),y)
RTK8723DU_DEPENDENCIES = linux
define RTK8723DU_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl8723DU ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8723DU_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8723DU_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8723DU/8723du.ko $(RTK8723DU_INSTALL_DIR)
	echo $(RTK8723DU_MODULE_DIR)/8723du.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else
define RTK8723DU_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/realtek/drivers;
	ln -sf $(RTK8723DU_DIR) $(LINUX_DIR)/../hardware/wifi/realtek/drivers/8723dU
endef
endif
$(eval $(generic-package))
