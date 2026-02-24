################################################################################
#
# amlogic 8188gtv driver
#
################################################################################

RTK8188GTV_VERSION = $(call qstrip,$(BR2_PACKAGE_RTK8188GTV_GIT_VERSION))
RTK8188GTV_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8188GTV_GIT_REPO_URL))
RTK8188GTV_MODULE_DIR = kernel/realtek/wifi
RTK8188GTV_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(RTK8188GTV_MODULE_DIR)
RTK8188GTV_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_RTK8188GTV_LOCAL),y)
RTK8188GTV_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8188GTV_LOCAL_PATH))
RTK8188GTV_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_RTK8188GTV_STANDALONE),y)
define RTK8188GTV_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl8188GTV ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8188GTV_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8188GTV_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8188GTV/8188gtvu.ko $(RTK8188GTV_INSTALL_DIR)
	echo $(RTK8188GTV_MODULE_DIR)/8188gtvu.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else
define RTK8188GTV_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/realtek/drivers;
	ln -sf $(RTK8188GTV_DIR) $(LINUX_DIR)/../hardware/wifi/realtek/drivers/rtk8188gtv
endef
endif
$(eval $(generic-package))
