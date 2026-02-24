################################################################################
#
# amlogic pmz drivers
#
################################################################################

PMZ_SITE_METHOD = local
PMZ_VERSION = 1.0
PMZ_INSTALL_STAGING:=YES

# modules
PMZ_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/pmz
PMZ_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
PMZ_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
PMZ_MODULE_DIR := kernel/mbp/
PMZ_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/pmz)
PMZ_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/pmz
PMZ_TMP = $(TOPDIR)/../output/pmz-tmp
PMZ_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/pmz/pmz.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-pmz-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define PMZ_RELEASE_PACKAGE
	-mkdir -p $(PMZ_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(PMZ_TMP); \
		fi; \
	done < $(@D)/pmz.filelist

	-tar --transform 's,^,mbd/pmz/,S' \
	-czf $(TARGET_DIR)/../images/ipc-pmz-prebuilt.tgz \
	-C $(PMZ_TMP)/$(@D) .
	-rm -rf $(PMZ_TMP)
endef
define PMZ_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "PMZ: LACK of prebuilt release filelist!"
endef
define PMZ_TOUCH_O_CMD
	for i in $(shell find $(PMZ_SITE) -name "*.o");do \
		echo $$i;\
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*pmz/};\
		echo $$nameAndDir;\
		filename=$${basename##*/};\
		dirname=$${nameAndDir%/*};\
		echo $$dirname;\
		touch $(@D)/$$dirname/.$$filename.o.cmd;\
	done
endef

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

ifneq ($(PMZ_LOCAL_SRC),)
PMZ_SITE = $(PMZ_LOCAL_SRC)
PMZ_DEPENDENCIES = linux-osal mbd-base
ifneq ($(PMZ_FILELIST),)
PMZ_POST_INSTALL_STAGING_HOOKS += PMZ_RELEASE_PACKAGE
else
PMZ_POST_INSTALL_STAGING_HOOKS += PMZ_LACK_WARNING
endif
else # prebuilt
PMZ_SITE = $(PMZ_LOCAL_PREBUILT)
PMZ_DEPENDENCIES = linux-osal mbd-base
PMZ_POST_RSYNC_HOOKS += PMZ_TOUCH_O_CMD
endif

PMZ_EXTRA_CFLAGS = \
-I$(@D)/include \
-I$(LINUX_OSAL_DIR)/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/include

PMZ_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifeq ($(BR2_ARM_KERNEL_64)$(BR2_arm),yy)
    PMZ_EXTRA_CFLAGS += -DUSER_32_KERNEL_64
endif

ifneq ($(PMZ_LOCAL_SRC),)
define PMZ_BUILD_CMDS
	echo PMZ EXTRA_CFLAGS $(PMZ_EXTRA_CFLAGS)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(PMZ_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define PMZ_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define PMZ_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(PMZ_INSTALL_STAGING_DIR)/
endef

define PMZ_INSTALL_TARGET_CMDS
	$(call copy-pmz-module,$(@D),\
		$(shell echo $(PMZ_INSTALL_DIR)),\
		$(shell echo $(PMZ_DEP)),\
		$(PMZ_MODULE_DIR))
endef

else # prebuilt



define PMZ_BUILD_CMDS
	echo PMZ EXTRA_CFLAGS $(PMZ_EXTRA_CFLAGS)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(PMZ_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define PMZ_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef
define PMZ_INSTALL_TARGET_CMDS
	$(call copy-pmz-module,$(@D),\
		$(shell echo $(PMZ_INSTALL_DIR)),\
		$(shell echo $(PMZ_DEP)),\
		$(PMZ_MODULE_DIR))
endef
endif
$(eval $(generic-package))
