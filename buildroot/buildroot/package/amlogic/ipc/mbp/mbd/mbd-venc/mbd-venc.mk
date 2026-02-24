################################################################################
#
# amlogic venc drivers
#
################################################################################

MBD_VENC_SITE_METHOD = local
MBD_VENC_VERSION = 1.0
MBD_VENC_INSTALL_STAGING:=YES

# modules
MBD_VENC_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/mbd/venc
MBD_VENC_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_VENC_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_VENC_MODULE_DIR := kernel/mbp/mbd
MBD_VENC_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/venc)
MBD_VENC_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/venc
MBD_VENC_TMP = $(TOPDIR)/../output/venc-tmp
MBD_VENC_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/venc/venc.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-venc-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_VENC_RELEASE_PACKAGE
	-mkdir -p $(MBD_VENC_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_VENC_TMP); \
		fi; \
	done < $(@D)/venc.filelist

	-tar --transform 's,^,mbd/venc/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-venc-prebuilt.tgz \
	-C $(MBD_VENC_TMP)/$(@D) .
	-rm -rf $(MBD_VENC_TMP)
endef

define MBD_VENC_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-VENC: LACK of prebuilt release filelist!"
endef

define MBD_VENC_TOUCH_O_CMD
	for i in $(shell find $(MBD_VENC_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*venc/};\
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

ifneq ($(MBD_VENC_LOCAL_SRC),)
MBD_VENC_SITE = $(MBD_VENC_LOCAL_SRC)
ifneq ($(MBD_VENC_FILELIST),)
MBD_VENC_POST_INSTALL_STAGING_HOOKS += MBD_VENC_RELEASE_PACKAGE
else
MBD_VENC_POST_INSTALL_STAGING_HOOKS += MBD_VENC_LACK_WARNING
endif

else # prebuilt
MBD_VENC_SITE = $(MBD_VENC_LOCAL_PREBUILT)
MBD_VENC_POST_RSYNC_HOOKS += MBD_VENC_TOUCH_O_CMD
endif

MBD_VENC_DEPENDENCIES = mbd-base

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_VENC_EXTRA_CFLAGS = \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \

 MBD_VENC_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_VENC_LOCAL_SRC),)
define MBD_VENC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_VENC_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules
endef

define MBD_VENC_CLEAN_CMDS
	$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@) ARCH=$(KERNEL_ARCH) clean
endef

define MBD_VENC_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_VENC_INSTALL_STAGING_DIR)/
endef

define MBD_VENC_INSTALL_TARGET_CMDS
	$(call copy-venc-module,$(@D),\
		$(shell echo $(MBD_VENC_INSTALL_DIR)),\
		$(shell echo $(MBD_VENC_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt

define MBD_VENC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_VENC_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules
endef

define MBD_VENC_CLEAN_CMDS
	$(TARGET_CONFIGURE_OPTS)$(MAKE) -C $(LINUX_DIR) M=$(@) ARCH=$(KERNEL_ARCH) clean
endef

define MBD_VENC_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_VENC_INSTALL_TARGET_CMDS
	$(call copy-venc-module,$(@D),\
		$(shell echo $(MBD_VENC_INSTALL_DIR)),\
		$(shell echo $(MBD_VENC_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif
$(eval $(generic-package))
