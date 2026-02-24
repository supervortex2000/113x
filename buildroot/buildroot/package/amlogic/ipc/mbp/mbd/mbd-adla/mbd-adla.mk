################################################################################
#
# amlogic adla drivers
#
################################################################################

MBD_ADLA_SITE_METHOD = local
MBD_ADLA_VERSION = 1.0
MBD_ADLA_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/npu/adla
MBD_ADLA_INSTALL_STAGING:=YES
# modules
MBD_ADLA_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/adla
MBD_ADLA_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_ADLA_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_ADLA_MODULE_DIR := kernel/mbp/mbd
MBD_ADLA_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/npu/adla)
MBD_ADLA_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/npu/adla
MBD_ADLA_TMP = $(TOPDIR)/../output/adla-tmp
MBD_ADLA_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/npu/adla/adla.filelist)

export CPU_TYPE='cortex-a53'
export FPU_TYPE='neon-vfpv4'

define MBD_ADLA_RELEASE_PACKAGE
	-mkdir -p $(MBD_ADLA_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_ADLA_TMP); \
		fi; \
	done < $(@D)/adla.filelist

	-tar --transform 's,^,mbd/npu/adla/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-adla-prebuilt.tgz \
	-C $(MBD_ADLA_TMP)/$(@D) .
	-rm -rf $(MBD_ADLA_TMP)
endef

define MBD_ADLA_LACK_WARINING
	@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-ADLA: LACK of prebuilt release filelist!"
endef

define copy-adla-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_ADLA_TOUCH_O_CMD
		for i in $(shell find $(MBD_ADLA_LOCAL_PREBUILT) -name "*.o");do \
			basename=$${i%%.o};\
			echo $$basename;\
			nameAndDir=$${basename##*adla/};\
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

MBD_ADLA_DEPENDENCIES = linux-osal
MBD_ADLA_DEPENDENCIES += pmz
MBD_ADLA_DEPENDENCIES += mbd-base

ifneq ($(MBD_ADLA_LOCAL_SRC),)
MBD_ADLA_SITE = $(MBD_ADLA_LOCAL_SRC)
ifneq ($(MBD_ADLA_FILELIST),)
MBD_ADLA_POST_INSTALL_STAGING_HOOKS += MBD_ADLA_RELEASE_PACKAGE
else
MBD_ADLA_POST_INSTALL_STAGING_HOOKS += MBD_ADLA_LACK_WARINING
endif

else # prebuilt
MBD_ADLA_SITE = $(MBD_ADLA_LOCAL_PREBUILT)
MBD_ADLA_POST_RSYNC_HOOKS += MBD_ADLA_TOUCH_O_CMD
endif

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_ADLA_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/include


ADLA_EXTRA_CFLAGS = -I$(@D)
ADLA_EXTRA_CFLAGS += -I$(@D)/drv
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/common
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/common/mm
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/port
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/port/os/linux
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/port/os/linux/mm
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/port/platform
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/port/platform/linux
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/uapi
ADLA_EXTRA_CFLAGS += -I$(@D)/drv/uapi/linux


HAS_PM_DOMAIN = 1
ADLA_DEBUG = 0

ADLA_EXTRA_CFLAGS += -DCONFIG_USE_MBP_ARCH=1


ifeq ($(ADLA_DEBUG),1)
ADLA_EXTRA_CFLAGS += -DCONFIG_ADLAK_DEBUG=1
endif
ifeq ($(HAS_PM_DOMAIN),1)
ADLA_EXTRA_CFLAGS += -DCONFIG_HAS_PM_DOMAIN=1
endif

MBD_ADLA_EXTRA_CFLAGS += $(ADLA_EXTRA_CFLAGS)
MBD_ADLA_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)


ifneq ($(MBD_ADLA_LOCAL_SRC),)
define MBD_ADLA_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_ADLA_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
        #$(shell echo "MBD_ADLA_EXTRA_CFLAGS= $(MBD_ADLA_EXTRA_CFLAGS)")
endef

define MBD_ADLA_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_ADLA_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_ADLA_INSTALL_STAGING_DIR)/
endef


define MBD_ADLA_INSTALL_TARGET_CMDS
	$(call copy-adla-module,$(@D),\
		$(shell echo $(MBD_ADLA_INSTALL_DIR)),\
		$(shell echo $(MBD_ADLA_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt
define MBD_ADLA_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_ADLA_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_ADLA_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_ADLA_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_ADLA_INSTALL_TARGET_CMDS
	$(call copy-adla-module,$(@D),\
		$(shell echo $(MBD_ADLA_INSTALL_DIR)),\
		$(shell echo $(MBD_ADLA_DEP)),\
		$(BASE_MODULE_DIR))
endef

endif

$(eval $(generic-package))
