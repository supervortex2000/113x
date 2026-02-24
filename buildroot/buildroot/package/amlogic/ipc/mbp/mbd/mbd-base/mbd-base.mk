################################################################################
#
# amlogic base drivers
#
################################################################################

MBD_BASE_SITE_METHOD = local
MBD_BASE_VERSION = 1.0
MBD_BASE_INSTALL_STAGING:=YES

# modules
MBD_BASE_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/base
MBD_BASE_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_BASE_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_BASE_MODULE_DIR := kernel/mbp/mbd
MBD_BASE_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/base)
MBD_BASE_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/base
MBD_BASE_TMP = $(TOPDIR)/../output/base-tmp
MBD_BASE_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/base/base.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-base-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_BASE_RELEASE_PACKAGE
	-mkdir -p $(MBD_BASE_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_BASE_TMP); \
		fi; \
	done < $(@D)/base.filelist

	-tar --transform 's,^,mbd/base/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-base-prebuilt.tgz \
	-C $(MBD_BASE_TMP)/$(@D) .
	-rm -rf $(MBD_BASE_TMP)
endef

define MBD_BASE_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-BASE: LACK of prebuilt release filelist!"
endef

ifneq ($(MBD_BASE_LOCAL_SRC),)
MBD_BASE_SITE = $(MBD_BASE_LOCAL_SRC)
MBD_BASE_DEPENDENCIES = linux-osal
ifneq ($(MBD_BASE_FILELIST),)
MBD_BASE_POST_INSTALL_STAGING_HOOKS += MBD_BASE_RELEASE_PACKAGE
else
MBD_BASE_POST_INSTALL_STAGING_HOOKS += MBD_BASE_LACK_WARNING
endif

else # prebuilt
MBD_BASE_SITE = $(MBD_BASE_LOCAL_PREBUILT)
MBD_BASE_DEPENDENCIES = linux-osal
endif

CHIP_NAME := AML_C3
MBP_VERSION := 1.0.0.RC4.1

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_BASE_EXTRA_CFLAGS = \
-I$(@D)/include \
-I$(@D)/log/include \
-I$(@D)/cppi/include \
-I$(@D)/sys/include \
-I$(@D)/vbp/include \
-I$(@D)/dummy/include \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/pmz/include \
-I$(LINUX_OSAL_DIR)/include \
-I$(STAGING_DIR)/usr/include/linux

MBD_BASE_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__) -D__CHIP_NAME__=$(CHIP_NAME) -D_MBP_VERSION_=$(MBP_VERSION)

define MBD_BASE_COMMON_MODULES
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/cppi ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_BASE_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers

	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/log ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_BASE_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules

	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/sys ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_BASE_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules

	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/vbp ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_BASE_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef


ifneq ($(MBD_BASE_LOCAL_SRC),)
define MBD_BASE_BUILD_CMDS
	$(MBD_BASE_COMMON_MODULES)
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/dummy ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_BASE_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_BASE_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/sys ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/vbp ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/cppi ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/log ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/dummy ARCH=$(KERNEL_ARCH) clean
endef

define MBD_BASE_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_BASE_INSTALL_STAGING_DIR)/
endef

else # prebuilt

define MBD_BASE_TOUCH_O_CMD
		for i in $(shell find $(MBD_BASE_SITE) -name "*.o");do \
			basename=$${i%%.o};\
			echo $$basename;\
			nameAndDir=$${basename##*base/};\
			filename=$${basename##*/}; \
			if [[ $$nameAndDir =~ "/" ]];then \
				dirname=$${nameAndDir%/*}; \
				full_o_cmd=$(@D)/$$dirname/.$$filename.o.cmd; \
			else \
				full_o_cmd=$(@D)/.$$filename.o.cmd; \
			fi; \
			echo "full touch path: " $$full_o_cmd; \
			touch $$full_o_cmd; \
		done
endef

MBD_BASE_POST_RSYNC_HOOKS += MBD_BASE_TOUCH_O_CMD

define MBD_BASE_BUILD_CMDS
	$(MBD_BASE_COMMON_MODULES)
endef

define MBD_BASE_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/sys ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/vbp ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/cppi ARCH=$(KERNEL_ARCH) clean
	@$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@)/log ARCH=$(KERNEL_ARCH) clean
endef

define MBD_BASE_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

endif

define MBD_BASE_INSTALL_TARGET_CMDS
	$(call copy-base-module,$(@D),\
		$(shell echo $(MBD_BASE_INSTALL_DIR)),\
		$(shell echo $(MBD_BASE_DEP)),\
		$(BASE_MODULE_DIR))
endef

$(eval $(generic-package))
