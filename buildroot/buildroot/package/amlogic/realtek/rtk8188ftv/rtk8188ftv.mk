################################################################################
#
# amlogic 8188ftv driver
#
################################################################################

RTK8188FTV_VERSION = $(call qstrip,$(BR2_PACKAGE_RTK8188FTV_GIT_VERSION))
RTK8188FTV_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8188FTV_GIT_REPO_URL))
RTK8188FTV_MODULE_DIR = kernel/realtek/wifi
RTK8188FTV_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(RTK8188FTV_MODULE_DIR)
RTK8188FTV_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_RTK8188FTV_LOCAL),y)
RTK8188FTV_SITE = $(call qstrip,$(BR2_PACKAGE_RTK8188FTV_LOCAL_PATH))
RTK8188FTV_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_RTK8188FTV_STANDALONE),y)
define RTK8188FTV_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl8188FU ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8188FTV_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8188FTV_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8188FU/8188fu.ko $(RTK8188FTV_INSTALL_DIR)
	echo $(RTK8188FTV_MODULE_DIR)/8188fu.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
else
define RTK8188FTV_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/rtl8188FTV ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef
define RTK8188FTV_INSTALL_TARGET_CMDS
	mkdir -p $(RTK8188FTV_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/rtl8188FTV/8188ftv.ko $(RTK8188FTV_INSTALL_DIR)
	echo $(RTK8188FTV_MODULE_DIR)/8188ftv.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endef
endif
$(eval $(generic-package))
