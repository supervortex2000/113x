################################################################################
#
# amlogic linux osal drivers
#
################################################################################

LINUX_OSAL_SITE_METHOD = local
LINUX_OSAL_VERSION = 1.0
LINUX_OSAL_INSTALL_STAGING:=YES

# modules
LINUX_OSAL_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/mbp/osal
LINUX_OSAL_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
LINUX_OSAL_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
LINUX_OSAL_MODULE_DIR := kernel/mbp
LINUX_OSAL_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux)
LINUX_OSAL_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/osal/linux
LINUX_OSAL_TMP = $(TOPDIR)/../output/linux-osal-tmp
LINUX_OSAL_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/linux-osal.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define copy-osal-module
	$(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/ -rfa;\
		echo $(4)/$(notdir $(m)): >> $(3)))
endef

define LINUX_OSAL_RELEASE_PACKAGE
	-mkdir -p $(LINUX_OSAL_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(LINUX_OSAL_TMP); \
		fi; \
	done < $(@D)/linux-osal.filelist

	-tar --transform 's,^,osal/linux/,S' \
	-czf $(TARGET_DIR)/../images/ipc-linux-osal-prebuilt.tgz \
	-C $(LINUX_OSAL_TMP)/$(@D) .
	-rm -rf $(LINUX_OSAL_TMP)
endef
define LINUX_OSAL_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "LINUX-OSAL: LACK of prebuilt release filelist!"
endef
ifneq ($(LINUX_OSAL_LOCAL_SRC),)
LINUX_OSAL_SITE = $(LINUX_OSAL_LOCAL_SRC)
ifneq ($(LINUX_OSAL_FILELIST),)
LINUX_OSAL_POST_INSTALL_STAGING_HOOKS += LINUX_OSAL_RELEASE_PACKAGE
else
LINUX_OSAL_POST_INSTALL_STAGING_HOOKS += LINUX_OSAL_LACK_WARNING
endif
else
LINUX_OSAL_SITE = $(LINUX_OSAL_LOCAL_PREBUILT)
endif

LINUX_OSAL_DEPENDENCIES = linux

LINUX_OSAL_EXTRA_CFLAGS = \
-I$(@D)/include \
-I$(@D)/src \

define LINUX_OSAL_BUILD_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_KERNEL_CROSS) EXTRA_CFLAGS="$(LINUX_OSAL_EXTRA_CFLAGS)" modules
endef

define LINUX_OSAL_CLEAN_CMDS
	@$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define LINUX_OSAL_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/include/* $(LINUX_OSAL_INSTALL_STAGING_DIR)/
endef

define LINUX_OSAL_INSTALL_TARGET_CMDS
	$(call copy-osal-module,$(@D),\
		$(shell echo $(LINUX_OSAL_INSTALL_DIR)),\
		$(shell echo $(LINUX_OSAL_DEP)),\
		$(LINUX_OSAL_MODULE_DIR))
endef

$(eval $(generic-package))
