################################################################################
#
# amlogic ge2d drivers
#
################################################################################

MBD_GE2D_SITE_METHOD = local
MBD_GE2D_VERSION = 1.0
MBD_GE2D_INSTALL_STAGING:=YES
# modules
MBD_GE2D_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/ge2d
MBD_GE2D_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_GE2D_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_GE2D_MODULE_DIR := kernel/mbp/mbd
MBD_GE2D_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/ge2d)
MBD_GE2D_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/ge2d
MBD_GE2D_TMP = $(TOPDIR)/../output/ge2d-tmp
MBD_GE2D_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/ge2d/ge2d.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-ge2d-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_GE2D_RELEASE_PACKAGE
	-mkdir -p $(MBD_GE2D_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_GE2D_TMP); \
		fi; \
	done < $(@D)/ge2d.filelist

	-tar --transform 's,^,mbd/ge2d/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-ge2d-prebuilt.tgz \
	-C $(MBD_GE2D_TMP)/$(@D) .
	-rm -rf $(MBD_GE2D_TMP)
endef

define MBD_GE2D_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-GE2D: LACK of prebuilt release filelist!"
endef

define MBD_GE2D_TOUCH_O_CMD
	for i in $(shell find $(MBD_GE2D_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*ge2d/};\
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

ifneq ($(MBD_GE2D_LOCAL_SRC),)
MBD_GE2D_SITE = $(MBD_GE2D_LOCAL_SRC)
ifneq ($(MBD_GE2D_FILELIST),)
MBD_GE2D_POST_INSTALL_STAGING_HOOKS += MBD_GE2D_RELEASE_PACKAGE
else
MBD_GE2D_POST_INSTALL_STAGING_HOOKS += MBD_GE2D_LACK_WARNING
endif

else # prebuilt
MBD_GE2D_SITE = $(MBD_GE2D_LOCAL_PREBUILT)
MBD_GE2D_POST_RSYNC_HOOKS += MBD_GE2D_TOUCH_O_CMD
endif

MBD_GE2D_DEPENDENCIES = linux-osal
MBD_GE2D_DEPENDENCIES += pmz
MBD_GE2D_DEPENDENCIES += mbd-base

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_GE2D_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(LINUX_OSAL_DIR)/include

 MBD_GE2D_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_GE2D_LOCAL_SRC),)
define MBD_GE2D_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_GE2D_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_GE2D_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_GE2D_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_GE2D_INSTALL_STAGING_DIR)/
endef

define MBD_GE2D_INSTALL_TARGET_CMDS
	$(call copy-ge2d-module,$(@D),\
		$(shell echo $(MBD_GE2D_INSTALL_DIR)),\
		$(shell echo $(MBD_GE2D_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt
define MBD_GE2D_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_GE2D_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_GE2D_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_GE2D_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_GE2D_INSTALL_TARGET_CMDS
	$(call copy-ge2d-module,$(@D),\
		$(shell echo $(MBD_GE2D_INSTALL_DIR)),\
		$(shell echo $(MBD_GE2D_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif
$(eval $(generic-package))
