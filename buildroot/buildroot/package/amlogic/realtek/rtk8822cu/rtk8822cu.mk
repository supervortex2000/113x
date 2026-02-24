################################################################################
#
# amlogic 8822cu driver
#
################################################################################

RTK8822CU_VERSION = $(call qstrip,$(BR2_PACKAGE_RTK8822CU_GIT_VERSION))
RTK8822CU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8822CU_GIT_REPO_URL))
RTK8822CU_MODULE_DIR = kernel/realtek/wifi
RTK8822CU_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(RTK8822CU_MODULE_DIR)

ifeq ($(BR2_PACKAGE_RTK8822CU_LOCAL),y)
RTK8822CU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8822CU_LOCAL_PATH))
RTK8822CU_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_RTK8822CU_STANDALONE),y)
RTK8822CU_DEPENDENCIES = linux
endif

ifeq ($(BR2_PACKAGE_RTK8822CU_STANDALONE),y)
define RTK8822CU_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl88x2CU ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8822CU_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8822CU_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl88x2CU/88x2cu.ko $(RTK8822CU_INSTALL_DIR)
	echo $(RTK8822CU_MODULE_DIR)/88x2cu.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else

define RTK8822CU_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/realtek/drivers;
	ln -sf $(RTK8822CU_DIR) $(LINUX_DIR)/../hardware/wifi/realtek/drivers/8822cu
endef
endif
$(eval $(generic-package))
