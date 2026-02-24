################################################################################
#
# amlogic dewarp drivers
#
################################################################################

MBD_DEWARP_SITE_METHOD = local
MBD_DEWARP_VERSION = 1.0
MBD_DEWARP_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/dewarp
MBD_DEWARP_INSTALL_STAGING:=YES
# modules
MBD_DEWARP_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/dewarp
MBD_DEWARP_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_DEWARP_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_DEWARP_MODULE_DIR := kernel/mbp/mbd
MBD_DEAWRP_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/dewarp)
MBD_DEWARP_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/dewarp
MBD_DEWARP_TMP = $(TOPDIR)/../output/dewarp-tmp
MBD_DEWARP_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/dewarp/dewarp.filelist)

define copy-dewarp-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_DEWARP_RELEASE_PACKAGE
	-mkdir -p $(MBD_DEWARP_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_DEWARP_TMP); \
		fi; \
	done < $(@D)/dewarp.filelist

	-tar --transform 's,^,mbd/dewarp/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-dewarp-prebuilt.tgz \
	-C $(MBD_DEWARP_TMP)/$(@D) .
	-rm -rf $(MBD_DEWARP_TMP)
endef

define MBD_DEWARP_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-DEWARP: LACK of prebuilt release filelist!"
endef

MBD_DEWARP_DEPENDENCIES = linux-osal
MBD_DEWARP_DEPENDENCIES += pmz
MBD_DEWARP_DEPENDENCIES += mbd-base

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_DEWARP_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/include

MBD_DEWARP_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_DEAWRP_LOCAL_SRC),)
MBD_DEWARP_SITE = $(MBD_DEAWRP_LOCAL_SRC)
ifneq ($(MBD_DEWARP_FILELIST),)
MBD_DEWARP_POST_INSTALL_STAGING_HOOKS += MBD_DEWARP_RELEASE_PACKAGE
else
MBD_DEWARP_POST_INSTALL_STAGING_HOOKS += MBD_DEWARP_LACK_WARNING
endif

define MBD_DEWARP_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_DEWARP_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules

endef

define MBD_DEWARP_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_DEWARP_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_DEWARP_INSTALL_STAGING_DIR)/
endef


define MBD_DEWARP_INSTALL_TARGET_CMDS
	$(call copy-dewarp-module,$(@D),\
		$(shell echo $(MBD_DEWARP_INSTALL_DIR)),\
		$(shell echo $(MBD_DEWARP_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt

MBD_DEWARP_SITE = $(MBD_DEWARP_LOCAL_PREBUILT)

define MBD_DEWARP_TOUCH_O_CMD
	for i in $(shell find $(MBD_DEWARP_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*dewarp/};\
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

MBD_DEWARP_POST_RSYNC_HOOKS += MBD_DEWARP_TOUCH_O_CMD

define MBD_DEWARP_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_DEWARP_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules

endef

define MBD_DEWARP_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_DEWARP_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_DEWARP_INSTALL_TARGET_CMDS
	$(call copy-dewarp-module,$(@D),\
		$(shell echo $(MBD_DEWARP_INSTALL_DIR)),\
		$(shell echo $(MBD_DEWARP_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif

$(eval $(generic-package))
