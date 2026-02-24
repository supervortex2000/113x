################################################################################
#
#tuner driver
#
################################################################################
TUNER_SITE = $(TOPDIR)/../vendor/amlogic/tuner
TUNER_SITE_METHOD = local
TUNER_DEPENDENCIES = linux

TUNER_KO_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/tuner
TUNER_KO_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
TUNER_KO_MODULE_DIR := kernel/tuner

KERNEL_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_VERSION_VALUE))
TUNER_KO_VERSION = $(shell echo $(KERNEL_VERSION) | cut -d'-' -f2)

ifeq ($(BR2_ARM_KERNEL_32),y)
	KERNEL_BITS = 32
else
	KERNEL_BITS = 64
endif

define copy-tuner-modules
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/$(subst _$(KERNEL_BITS),,$(notdir $(m))) -rfa;\
		echo $(4)/$(subst _$(KERNEL_BITS),,$(notdir $(m))): >> $(3)))
endef

#define TUNER_BUILD_CMDS
#	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
#		M=$(@D) ARCH=$(KERNEL_ARCH) \
#		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) $(CONFIGS) modules
#endef

#define TUNER_CLEAN_CMDS
#	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
#endef

define TUNER_INSTALL_TARGET_CMDS
	$(call copy-tuner-modules,$(@D)/$(TUNER_KO_VERSION)/$(KERNEL_BITS),\
		$(shell echo $(TUNER_KO_INSTALL_DIR)),\
		$(shell echo $(TUNER_KO_DEP)),\
		$(TUNER_KO_MODULE_DIR))
endef

$(eval $(generic-package))
