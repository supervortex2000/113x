################################################################################
#
# amlogic 8821cu driver
#
################################################################################

RTK8821CU_VERSION = $(call qstrip,$(BR2_PACKAGE_RTK8821CU_GIT_VERSION))
RTK8821CU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8821CU_GIT_REPO_URL))
RTK8821CU_MODULE_DIR = kernel/realtek/wifi
RTK8821CU_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(RTK8821CU_MODULE_DIR)

ifeq ($(BR2_PACKAGE_RTK8821CU_LOCAL),y)
RTK8821CU_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8821CU_LOCAL_PATH))
RTK8821CU_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_RTK8821CU_STANDALONE),y)
RTK8821CU_DEPENDENCIES = linux
endif

ifeq ($(BR2_PACKAGE_RTK8821CU_STANDALONE),y)
define RTK8821CU_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl8821CU ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8821CU_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8821CU_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8821CU/8821cu.ko $(RTK8821CU_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8821CU/8821cu.ko $(TARGET_DIR)/lib/modules
	echo $(RTK8821CU_MODULE_DIR)/8821cu.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else

define RTK8821CU_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/realtek/drivers;
	ln -sf $(RTK8821CU_DIR) $(LINUX_DIR)/../hardware/wifi/realtek/drivers/8821cu
endef
endif
$(eval $(generic-package))
