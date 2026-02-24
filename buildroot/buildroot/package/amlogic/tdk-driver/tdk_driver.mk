#############################################################
#
# TDK driver
#
#############################################################
ifneq ($(BR2_PACKAGE_TDK_LOCAL_PATH),"")
  TDK_DRIVER_SITE = $(call qstrip,$(BR2_PACKAGE_TDK_LOCAL_PATH))/linuxdriver
else
  TDK_DRIVER_SITE = $(TOPDIR)/../vendor/amlogic/tdk/linuxdriver
endif
TDK_DRIVER_SITE_METHOD = local
TDK_VERSION = $(call qstrip,$(BR2_PACKAGE_TDK_VERSION))

TDK_DRIVER_INSTALL_STAGING = YES
TDK_DRIVER_DEPENDENCIES = linux

ifeq ($(BR2_aarch64), y)
_ARCH = arm64
_CROSS_COMPILE = aarch64-linux-gnu-
else
_ARCH = arm
_CROSS_COMPILE = arm-linux-gnueabihf-
endif

ifeq ($(BR2_ARM_KERNEL_32), y)
TARGET_CONFIGURE_OPTS += KERNEL_A32_SUPPORT=true
endif

ifeq ($(BR2_LINUX_KERNEL_VERSION),"amlogic-5.15-dev")
else ifeq ($(BR2_LINUX_KERNEL_VERSION),"amlogic-5.4-dev")
else
define TDK_DRIVER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) M=$(@D)/ ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules
endef

define TDK_DRIVER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/trustzone/
	$(INSTALL) -D -m 0644 $(@D)/optee/optee_armtz.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/trustzone/
	$(INSTALL) -D -m 0644 $(@D)/optee.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/trustzone/
	echo kernel/drivers/trustzone/optee_armtz.ko: kernel/drivers/trustzone/optee.ko >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	echo kernel/drivers/trustzone/optee.ko: >> $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
	echo "#OPTEE" >> $(TARGET_DIR)/etc/modules
	echo optee >> $(TARGET_DIR)/etc/modules
	echo optee_armtz >> $(TARGET_DIR)/etc/modules
endef
endif

$(eval $(generic-package))
