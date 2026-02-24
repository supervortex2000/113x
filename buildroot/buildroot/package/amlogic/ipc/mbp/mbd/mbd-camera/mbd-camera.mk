################################################################################
#
# amlogic camera drivers
#
################################################################################

MBD_CAMERA_SITE_METHOD = local
MBD_CAMERA_VERSION = 1.0
MBD_CAMERA_INSTALL_STAGING:=YES
# modules
MBD_CAMERA_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/camera
MBD_CAMERA_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_CAMERA_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_CAMERA_MODULE_DIR := kernel/mbp/mbd
MBD_CAMERA_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera)
MBD_CAMERA_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/camera
MBD_CAMERA_TMP = $(TOPDIR)/../output/camera-tmp
MBD_CAMERA_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera/camera.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-camera-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_CAMERA_RELEASE_PACKAGE
	-mkdir -p $(MBD_CAMERA_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_CAMERA_TMP); \
		fi; \
	done < $(@D)/camera.filelist

	-tar --transform 's,^,mbd/camera/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-camera-prebuilt.tgz \
	-C $(MBD_CAMERA_TMP)/$(@D) .
	-rm -rf $(MBD_CAMERA_TMP)
endef

define MBD_CAMERA_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-CAMERA: LACK of prebuilt release filelist!"
endef

ifneq ($(MBD_CAMERA_LOCAL_SRC),)
MBD_CAMERA_SITE = $(MBD_CAMERA_LOCAL_SRC)
ifneq ($(MBD_CAMERA_FILELIST),)
MBD_CAMERA_POST_INSTALL_STAGING_HOOKS += MBD_CAMERA_RELEASE_PACKAGE
else
MBD_CAMERA_POST_INSTALL_STAGING_HOOKS += MBD_CAMERA_LACK_WARNING
endif

else # prebuilt
MBD_CAMERA_SITE = $(MBD_CAMERA_LOCAL_PREBUILT)
endif

MBD_CAMERA_DEPENDENCIES = linux-osal
MBD_CAMERA_DEPENDENCIES += pmz
MBD_CAMERA_DEPENDENCIES += mbd-base
MBD_CAMERA_DEPENDENCIES += mbd-ppu

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_CAMERA_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(MBD_BASE_DIR)/pmz/include \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbi/isp/include \
-I$(MBD_CAMERA_DIR)/vi/include \
-I$(MBD_CAMERA_DIR)/isp/include \
-I$(MBD_CAMERA_DIR)/mipi_rx/include \
-I$(MBD_CAMERA_DIR)/vi2/include \
-I$(MBD_CAMERA_DIR)/mipi_rx2/include \
-I$(MBD_CAMERA_DIR)/ctrl/include \
-I$(MBD_PPU_DIR)/include \
-Wno-implicit-fallthrough \
-Wno-unused-variable \
-I$(STAGING_DIR)/usr/include/linux \
-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/include

MBD_CAMERA_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

define MBD_CAMERA_TOUCH_O_CMD
	for i in $(shell find $(MBD_CAMERA_SITE) -name "*.o");do \
		basename=$${i%%.o};\
		echo $$basename;\
		nameAndDir=$${basename##*camera/};\
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

ifneq ($(MBD_CAMERA_LOCAL_SRC),)
MBD_CAMERA_SITE = $(MBD_CAMERA_LOCAL_SRC)

define cam_module_func
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/$(1) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_CAMERA_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(@D)/isp/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_PPU_DIR)/Module.symvers modules
endef

define MBD_CAMERA_BUILD_CMDS
	$(call cam_module_func,isp)
	$(call cam_module_func,mipi_rx)
	$(call cam_module_func,vi)
	$(call cam_module_func,mipi_rx2)
	$(call cam_module_func,vi2)
	$(call cam_module_func,ctrl)

endef

define MBD_CAMERA_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/isp clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/mipi_rx clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/vi clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/mipi_rx2 clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/vi2 clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/ctrl clean
endef

define MBD_CAMERA_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/*/include/* $(MBD_CAMERA_INSTALL_STAGING_DIR)/
		$(INSTALL) -D -m 0644 $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbi/isp/include/* $(MBD_CAMERA_INSTALL_STAGING_DIR)/
endef

define MBD_CAMERA_INSTALL_TARGET_CMDS
	$(call copy-camera-module,$(@D),\
		$(shell echo $(MBD_CAMERA_INSTALL_DIR)),\
		$(shell echo $(MBD_CAMERA_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt
MBD_CAMERA_POST_RSYNC_HOOKS += MBD_CAMERA_TOUCH_O_CMD
define cam_module_func
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D)/$(1) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_CAMERA_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers \
		KBUILD_EXTRA_SYMBOLS+=$(@D)/isp/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_PPU_DIR)/Module.symvers modules
endef

define MBD_CAMERA_BUILD_CMDS
	$(call cam_module_func,isp)
	$(call cam_module_func,mipi_rx)
	$(call cam_module_func,vi)
	$(call cam_module_func,mipi_rx2)
	$(call cam_module_func,vi2)
	$(call cam_module_func,ctrl)

endef

define MBD_CAMERA_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/isp clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/mipi_rx clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/vi clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/mipi_rx2 clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/vi2 clean
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/ctrl clean

endef

define MBD_CAMERA_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/*/include/* $(STAGING_DIR)/usr/include/
endef

define MBD_CAMERA_INSTALL_TARGET_CMDS
	$(call copy-camera-module,$(@D),\
		$(shell echo $(MBD_CAMERA_INSTALL_DIR)),\
		$(shell echo $(MBD_CAMERA_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif
$(eval $(generic-package))
