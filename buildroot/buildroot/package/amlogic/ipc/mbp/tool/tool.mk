#############################################################
#
# tool
#
#############################################################

TOOL_VERSION = 1.0
TOOL_SITE_METHOD = local
TOOL_INSTALL_STAGING = YES
TOOL_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/tool)
TOOL_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/tool
TOOL_TMP = $(TOPDIR)/../output/tool-tmp
TOOL_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/tool/tool.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

TOOL_DEPENDENCIES = mbd-base mbi

TOOL_SITE = $(TOOL_LOCAL_SRC)
TOOL_CFLAGS := $(TARGET_CFLAGS)

TOOL_GIT_VERSION=$(shell \
			if [ -d $(TOOL_SITE)/.git ]; then \
			   git -C $(TOOL_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)
TOOL_CFLAGS = \
    -I$(MBD_BASE_DIR)/include \
    -I$(PMZ_DIR)/include \
    -I$(SAMPLE_DIR)/pipe_line/cfg \
    -I$(@D)/mbuffer/include \
    -I$(@D)/rtspserver/include \
    -I$(MBD_BASE_DIR)/include \
    -I$(MBD_BASE_DIR)/cppi/include \
    -I$(MBI_DIR)/vbp/include \
    -I$(MBI_DIR)/isp/include \
    -I$(PMZ_DIR)/include \
    -I$(MBD_CVE_DIR)/include \
    -I$(MBD_GE2D_DIR)/include \
    -I$(MBD_AUDIO_DIR)/include \
    -I$(MBD_VENC_DIR)/include \
    -I$(MBD_REGION_DIR)/include \
    -I$(MBD_ADLA_DIR)/include \
    -I$(MBD_DEWARP_DIR)/include \
    -I$(MBD_CAMERA_DIR)/isp/include \
    -I$(MBD_CAMERA_DIR)/mipi_rx/include \
    -I$(MBD_CAMERA_DIR)/vi/include \
    -I$(MBD_PPU_DIR)/include \
    -I$(MBD_VPU_DIR)/include


TOOL_MAKE_ENV = \
    $(TARGET_MAKE_ENV) \
    CFLAGS="$(TOOL_CFLAGS)" \
    MBI_LIBA_DIR=$(MBI_DIR)
ifeq ($(BR2_ARM_KERNEL_64)$(BR2_arm),yy)
    TOOL_CFLAGS  += -DUSER_32_KERNEL_64
endif

ifneq ($(TOOL_LOCAL_SRC),)
define TOOL_BUILD_CMDS
	    REVISION=$(TOOL_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(TOOL_CFLAGS)" $(MAKE) -C $(@D)/ipc_property
        REVISION=$(TOOL_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TOOL_MAKE_ENV) CFLAGS="$(TOOL_CFLAGS)" $(MAKE) -C $(@D)
endef
else
define TOOL_BUILD_CMDS
	    REVISION=$(TOOL_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(TOOL_CFLAGS)" $(MAKE) -C $(@D)/ipc_property
endef
endif

define TOOL_RELEASE_PACKAGE
	-mkdir -p $(TOOL_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(TOOL_TMP); \
		fi; \
	done < $(@D)/tool.filelist

	-tar --transform 's,^,tool/,S' \
	-czf $(TARGET_DIR)/../images/ipc-tool-prebuilt.tgz \
	-C $(TOOL_TMP)/$(@D) .
	-rm -rf $(TOOL_TMP)
endef

define TOOL_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "TOOL: LACK of prebuilt release filelist!"
endef

ifneq ($(TOOL_LOCAL_SRC),)
define TOOL_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libs/mbuffer/libmbuffer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/mbuffer/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/libs/rtspserver/librtspserver.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/rtspserver/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/libs/font/font.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/font/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/ipc_property/libipc-property.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ipc_property/ipc-property $(STAGING_DIR)/usr/bin/
	$(INSTALL) -D -m 644 $(@D)/ipc_property/ipc-property-service $(STAGING_DIR)/usr/bin/
	$(INSTALL) -D -m 644 $(@D)/ipc_property/startup.sh $(STAGING_DIR)/usr/bin/ipc-property-startup.sh
endef

define TOOL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/libs/mbuffer/libmbuffer.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/libs/rtspserver/librtspserver.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/libs/font/font.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/ipc_property/libipc-property.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/ipc_property/ipc-property $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/ipc_property/ipc-property-service $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/ipc_property/startup.sh $(TARGET_DIR)/usr/bin/ipc-property-startup.sh
endef

ifneq ($(TOOL_FILELIST),)
TOOL_POST_INSTALL_STAGING_HOOKS += TOOL_RELEASE_PACKAGE
else
TOOL_POST_INSTALL_STAGING_HOOKS += TOOL_LACK_WARNING
endif

else # prebuilt
TOOL_SITE = $(TOOL_LOCAL_PREBUILT)

define TOOL_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/libs/mbuffer/libmbuffer.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/mbuffer/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/libs/rtspserver/librtspserver.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/rtspserver/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/libs/font/font.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/libs/font/include/* $(STAGING_DIR)/usr/include/
	-$(INSTALL) -D -m 644 $(@D)/ipc_property/libipc-property.so $(STAGING_DIR)/usr/lib/
	-$(INSTALL) -D -m 644 $(@D)/ipc_property/ipc-property $(STAGING_DIR)/usr/bin/
	-$(INSTALL) -D -m 644 $(@D)/ipc_property/ipc-property-service $(STAGING_DIR)/usr/bin/
	-$(INSTALL) -D -m 644 $(@D)/ipc_property/startup.sh $(STAGING_DIR)/usr/bin/ipc-property-startup.sh
endef

define TOOL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/libs/mbuffer/libmbuffer.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/libs/rtspserver/librtspserver.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/libs/font/font.so $(TARGET_DIR)/usr/lib/
	-$(INSTALL) -D -m 755 $(@D)/ipc_property/libipc-property.so $(TARGET_DIR)/usr/lib/
	-$(INSTALL) -D -m 755 $(@D)/ipc_property/ipc-property $(TARGET_DIR)/usr/bin/
	-$(INSTALL) -D -m 755 $(@D)/ipc_property/ipc-property-service $(TARGET_DIR)/usr/bin/
	-$(INSTALL) -D -m 755 $(@D)/ipc_property/startup.sh $(TARGET_DIR)/usr/bin/ipc-property-startup.sh
endef
endif

$(eval $(generic-package))
