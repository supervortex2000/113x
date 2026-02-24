################################################################################
#
# amlogic npu driver
#
################################################################################
ifeq ($(BR2_PACKAGE_ACENNA_NPU_LOCAL),y)
#BR2_PACKAGE_NPU_LOCAL_PATH=$(TOPDIR)/../hardware/aml-4.9/npu/nanoq
ACENNA_NPU_SITE = $(call qstrip,$(BR2_PACKAGE_ACENNA_NPU_LOCAL_PATH))
ACENNA_NPU_SITE_METHOD = local
ACENNA_NPU_VERSION = 1.0
ARM_ACENNA_NPU_MODULE_DIR = kernel/amlogic/acenna_npu
ACENNA_NPU_KO_INSTALL_DIR=$(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/amlogic/acenna_npu
ACENNA_NPU_SO_INSTALL_DIR=$(TARGET_DIR)/usr/lib
ACENNA_NPU_DEPENDENCIES = linux

ARM_ACENNA_NPU_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep

define copy-arm-acenna-npu
        $(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
                $(shell [ ! -e $(2) ] && mkdir $(2) -p;\
                cp $(m) $(strip $(2))/ -rfa;\
                echo $(4)/$(notdir $(m)): >> $(3)))
endef

define ARM_ACENNA_NPU_DEP_INSTALL_TARGET_CMDS
        $(call copy-arm-acenna-npu,$(@D),\
                $(shell echo $(ACENNA_NPU_KO_INSTALL_DIR)),\
                $(shell echo $(ARM_ACENNA_NPU_DEP)),\
                $(ARM_ACENNA_NPU_MODULE_DIR))
endef

ifeq ($(BR2_aarch64), y)
ACENNA_NPU_INSTALL_TARGETS_CMDS = \
	$(INSTALL) -m 0755 $(@D)/kernel/acenna_kmod.ko $(ACENNA_NPU_KO_INSTALL_DIR); \
	$(INSTALL) -m 0755 $(@D)/sharelib/lib64/* $(ACENNA_NPU_SO_INSTALL_DIR);
else
ACENNA_NPU_INSTALL_TARGETS_CMDS = \
	$(INSTALL) -m 0755 $(@D)/kernel/acenna_kmod.ko $(ACENNA_NPU_KO_INSTALL_DIR); \
	$(INSTALL) -m 0755 $(@D)/sharelib/lib32/* $(ACENNA_NPU_SO_INSTALL_DIR);
endif

define ACENNA_NPU_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef


path = 	$(@D)
define ACENNA_NPU_BUILD_CMDS
	cd $(@D);./compiler.sh $(KERNEL_ARCH) $(LINUX_DIR) $(TARGET_KERNEL_CROSS)
endef
define ACENNA_NPU_INSTALL_TARGET_CMDS
	mkdir -p $(ACENNA_NPU_KO_INSTALL_DIR)
	$(ACENNA_NPU_INSTALL_TARGETS_CMDS)
	$(ARM_ACENNA_NPU_DEP_INSTALL_TARGET_CMDS)
endef

endif
$(eval $(generic-package))
