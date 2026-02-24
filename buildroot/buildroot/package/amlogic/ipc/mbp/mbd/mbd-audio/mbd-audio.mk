################################################################################
#
# amlogic audio drivers
#
################################################################################

MBD_AUDIO_SITE_METHOD = local
MBD_AUDIO_VERSION = 1.0
MBD_AUDIO_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/audio
MBD_AUDIO_INSTALL_STAGING:=YES
# modules
MBD_AUDIO_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/audio
MBD_AUDIO_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
MBD_AUDIO_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
MBD_AUDIO_MODULE_DIR := kernel/mbp/mbd
MBD_AUDIO_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/audio)
MBD_AUDIO_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/audio
MBD_AUDIO_TMP = $(TOPDIR)/../output/audio-tmp
MBD_AUDIO_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/audio/audio.filelist)

define copy-audio-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define MBD_AUDIO_RELEASE_PACKAGE
	-mkdir -p $(MBD_AUDIO_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBD_AUDIO_TMP); \
		fi; \
	done < $(@D)/audio.filelist

	-tar --transform 's,^,mbd/audio/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbd-audio-prebuilt.tgz \
	-C $(MBD_AUDIO_TMP)/$(@D) .
	-rm -rf $(MBD_AUDIO_TMP)
endef

define MBD_AUDIO_LACK_WARINING
	@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBD-AUDIO: LACK of prebuilt release filelist!"
endef

define MBD_AUDIO_TOUCH_O_CMD
		for i in $(shell find $(MBD_AUDIO_LOCAL_PREBUILT) -name "*.o");do \
			basename=$${i%%.o};\
			echo $$basename;\
			nameAndDir=$${basename##*mbd/audio/};\
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

MBD_AUDIO_DEPENDENCIES = linux-osal
MBD_AUDIO_DEPENDENCIES += pmz
MBD_AUDIO_DEPENDENCIES += mbd-base

BUILD_TIME = $(shell date +"%c")
__BUILD_TIME__ = \"$(BUILD_TIME)\"

MBD_AUDIO_EXTRA_CFLAGS = \
-I$(MBD_BASE_DIR)/include \
-I$(MBD_BASE_DIR)/log/include \
-I$(MBD_BASE_DIR)/cppi/include \
-I$(MBD_BASE_DIR)/sys/include \
-I$(MBD_BASE_DIR)/vbp/include \
-I$(MBD_BASE_DIR)/dummy/include \
-I$(@D)/include \
-I$(STAGING_DIR)/usr/include/linux \
-I$(LINUX_OSAL_DIR)/include

MBD_AUDIO_EXTRA_CFLAGS += -D__BUILD_TIME__=$(__BUILD_TIME__)

ifneq ($(MBD_AUDIO_LOCAL_SRC),)
MBD_AUDIO_SITE = $(MBD_AUDIO_LOCAL_SRC)
ifneq ($(MBD_AUDIO_FILELIST),)
MBD_AUDIO_POST_INSTALL_STAGING_HOOKS += MBD_AUDIO_RELEASE_PACKAGE
else
MBD_AUDIO_POST_INSTALL_STAGING_HOOKS += MBD_AUDIO_LACK_WARINING
endif
else # prebuilt
MBD_AUDIO_SITE = $(MBD_AUDIO_LOCAL_PREBUILT)
MBD_AUDIO_POST_RSYNC_HOOKS += MBD_AUDIO_TOUCH_O_CMD
endif

ifneq ($(MBD_AUDIO_LOCAL_SRC),)
define MBD_AUDIO_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_AUDIO_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules

endef

define MBD_AUDIO_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_AUDIO_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(MBD_AUDIO_INSTALL_STAGING_DIR)/
endef


define MBD_AUDIO_INSTALL_TARGET_CMDS
	$(call copy-audio-module,$(@D),\
		$(shell echo $(MBD_AUDIO_INSTALL_DIR)),\
		$(shell echo $(MBD_AUDIO_DEP)),\
		$(BASE_MODULE_DIR))
endef

else # prebuilt
define MBD_AUDIO_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(MBD_AUDIO_EXTRA_CFLAGS)" \
		KBUILD_EXTRA_SYMBOLS=$(LINUX_OSAL_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/cppi/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(PMZ_DIR)/Module.symvers modules \
		KBUILD_EXTRA_SYMBOLS+=$(MBD_BASE_DIR)/log/Module.symvers modules
endef

define MBD_AUDIO_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define MBD_AUDIO_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 0644 $(@D)/include/* $(STAGING_DIR)/usr/include/
endef
define MBD_AUDIO_INSTALL_TARGET_CMDS
	$(call copy-audio-module,$(@D),\
		$(shell echo $(MBD_AUDIO_INSTALL_DIR)),\
		$(shell echo $(MBD_AUDIO_DEP)),\
		$(BASE_MODULE_DIR))
endef
endif

$(eval $(generic-package))
