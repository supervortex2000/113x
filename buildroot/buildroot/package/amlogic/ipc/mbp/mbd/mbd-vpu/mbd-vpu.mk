################################################################################
#
# amlogic vpu drivers
#
################################################################################

MBD_VPU_SITE_METHOD = local
MBD_VPU_VERSION = 1.0
MBD_VPU_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/vpu
MBD_VPU_INSTALL_STAGING:=YES

# modules
MBD_VPU_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/mbd/vpu
MBD_VPU_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_VPU_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_VPU_MODULE_DIR := kernel/mbp/mbd
MBD_BASE_DIR = $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/base
MBD_VPU_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/vpu)
MBD_VPU_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/vpu
MBD_VPU_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/vpu/vpu.filelist)
MBD_VPU_TMP = $(TOPDIR)/../output/vpu-tmp

define MBD_VPU_RELEASE_PACKAGE
	-mkdir -p $(MBD_VPU_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_VPU_TMP); \
		fi; \
	done < $(@D)/vpu.filelist

	-tar --transform 's,^,mbd/vpu/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-vpu-prebuilt.tgz \
	-C $(MBD_VPU_TMP)/$(@D) .
	-rm -rf $(MBD_VPU_TMP)
endef

define MBD_VPU_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-VPU: LACK of prebuilt release filelist!"
endef

define MBD_VPU_TOUCH_O_CMD
	for i in $(shell find $(MBD_VPU_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*vpu/};\
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

define copy-vpu-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

MBD_VPU_DEPENDENCIES = linux-osal
MBD_VPU_DEPENDENCIES += mbd-base

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_VPU_EXTRA_CFLAGS = \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(@D)/region/include \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/include

 MBD_VPU_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_VPU_LOCAL_SRC),)
ifneq ($(MBD_VPU_FILELIST),)
MBD_VPU_POST_INSTALL_STAGING_HOOKS += MBD_VPU_RELEASE_PACKAGE
else
MBD_VPU_POST_INSTALL_STAGING_HOOKS += MBD_VPU_LACK_WARNING
endif

else # prebuilt
MBD_VPU_SITE = $(MBD_VPU_LOCAL_PREBUILT)
MBD_VPU_POST_RSYNC_HOOKS += MBD_VPU_TOUCH_O_CMD
endif

ifneq ($(MBD_VPU_LOCAL_SRC),)
define MBD_VPU_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_VPU_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers  \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_VPU_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_VPU_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_VPU_INSTALL_STAGING_DIR)/
endef

define MBD_VPU_INSTALL_TARGET_CMDS
	$(call copy-vpu-module,$(@D),\
		$(shell echo $(MBD_VPU_INSTALL_DIR)),\
		$(shell echo $(MBD_VPU_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt

define MBD_VPU_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_VPU_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_VPU_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_VPU_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/mbp_comm_vpu.h $(STAGING_DIR)/usr/include/
endef

define MBD_VPU_INSTALL_TARGET_CMDS
	$(call copy-vpu-module,$(@D),\
		$(shell echo $(MBD_VPU_INSTALL_DIR)),\
		$(shell echo $(MBD_VPU_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif

$(eval $(generic-package))
