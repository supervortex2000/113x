################################################################################
#
# icomm sv6158 driver
#
################################################################################

SV6158_VERSION = $(call qstrip,$(BR2_PACKAGE_SV6158_GIT_VERSION))
SV6158_SITE = $(call qstrip,$(BR2_PACKAGE_SV6158_GIT_REPO_URL))
SV6158_MODULE_DIR = kernel/icomm/wifi
SV6158_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/$(SV6158_MODULE_DIR)

ifeq ($(BR2_PACKAGE_SV6158_LOCAL),y)
SV6158_SITE = $(call qstrip,$(BR2_PACKAGE_SV6158_LOCAL_PATH))
SV6158_SITE_METHOD = local
endif
ifeq ($(BR2_PACKAGE_SV6158_STANDALONE),y)
SV6158_DEPENDENCIES = linux
endif

ifeq ($(BR2_PACKAGE_SV6158_STANDALONE),y)
define SV6158_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/sv6158 ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) KERNEL_OBJ_PATH=$(LINUX_DIR) SSV_DRV_PATH=$(@D)/sv6158 modules
endef
define SV6158_INSTALL_TARGET_CMDS
	mkdir -p $(SV6158_INSTALL_DIR)
	$(INSTALL) -m 0666 $(@D)/sv6158/ssv6x5x.ko $(SV6158_INSTALL_DIR)/sv6158.ko
	$(TARGET_KERNEL_CROSS)strip --strip-debug $(SV6158_INSTALL_DIR)/sv6158.ko
	echo $(SV6158_MODULE_DIR)/sv6158.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	mkdir -p $(TARGET_DIR)/etc/wifi/icomm
	$(INSTALL) -m 0666 $(@D)/sv6158/ssv6x5x-wifi.cfg $(TARGET_DIR)/etc/wifi/icomm/sv6158-wifi.cfg
endef
else

define SV6158_BUILD_CMDS
	mkdir -p $(LINUX_DIR)/../hardware/wifi/icomm/drivers/ssv6xxx/sv6158;
	ln -sf $(SV6158_DIR) $(LINUX_DIR)/../hardware/wifi/icomm/drivers/ssv6xxx/sv6158
endef
endif
$(eval $(generic-package))
