################################################################################
#
# amlogic ppu drivers
#
################################################################################

MBD_PPU_SITE_METHOD = local
MBD_PPU_VERSION = 1.0
MBD_PPU_INSTALL_STAGING:=YES
# modules
MBD_PPU_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/ppu
MBD_PPU_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_PPU_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_PPU_MODULE_DIR := kernel/mbp/mbd
MBD_PPU_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/ppu)
MBD_PPU_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/ppu
MBD_PPU_TMP = $(TOPDIR)/../output/ppu-tmp
MBD_PPU_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/ppu/ppu.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-ppu-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_PPU_RELEASE_PACKAGE
	-mkdir -p $(MBD_PPU_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_PPU_TMP); \
		fi; \
	done < $(@D)/ppu.filelist

	-tar --transform 's,^,mbd/ppu/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-ppu-prebuilt.tgz \
	-C $(MBD_PPU_TMP)/$(@D) .
	-rm -rf $(MBD_PPU_TMP)
endef

define MBD_PPU_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-PPU: LACK of prebuilt release filelist!"
endef

define MBD_PPU_TOUCH_O_CMD
	for i in $(shell find $(MBD_PPU_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*ppu/};\
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

ifneq ($(MBD_PPU_LOCAL_SRC),)
MBD_PPU_SITE = $(MBD_PPU_LOCAL_SRC)
ifneq ($(MBD_PPU_FILELIST),)
MBD_PPU_POST_INSTALL_STAGING_HOOKS += MBD_PPU_RELEASE_PACKAGE
else
MBD_PPU_POST_INSTALL_STAGING_HOOKS += MBD_PPU_LACK_WARNING
endif

else # prebuilt
MBD_PPU_SITE = $(MBD_PPU_LOCAL_PREBUILT)
MBD_PPU_POST_RSYNC_HOOKS += MBD_PPU_TOUCH_O_CMD
endif

MBD_PPU_DEPENDENCIES = linux-osal
MBD_PPU_DEPENDENCIES += pmz
MBD_PPU_DEPENDENCIES += mbd-base
MBD_PPU_DEPENDENCIES += mbd-dewarp
MBD_PPU_DEPENDENCIES += mbd-ge2d
MBD_PPU_DEPENDENCIES += mbd-region

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_PPU_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(MBD_GE2D_DIR)/include \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(LINUX_OSAL_DIR)/include

 MBD_PPU_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_PPU_LOCAL_SRC),)
define MBD_PPU_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_PPU_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_PPU_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_PPU_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_PPU_INSTALL_STAGING_DIR)/
endef

define MBD_PPU_INSTALL_TARGET_CMDS
	$(call copy-ppu-module,$(@D),\
		$(shell echo $(MBD_PPU_INSTALL_DIR)),\
		$(shell echo $(MBD_PPU_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt
define MBD_PPU_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_PPU_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_PPU_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_PPU_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_PPU_INSTALL_TARGET_CMDS
	$(call copy-ppu-module,$(@D),\
		$(shell echo $(MBD_PPU_INSTALL_DIR)),\
		$(shell echo $(MBD_PPU_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif
$(eval $(generic-package))
