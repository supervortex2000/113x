#############################################################
#
# IPC SDK
#
#############################################################

IPC_SDK_VERSION = 1.0
IPC_SDK_SITE_METHOD = local
IPC_SDK_INSTALL_STAGING = YES


IPC_SDK_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/ipc-sdk)
IPC_SDK_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/ipc-sdk-prebuilt

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

ifneq ($(IPC_SDK_LOCAL_SRC),)
IPC_SDK_SITE = $(IPC_SDK_LOCAL_SRC)
IPC_SDK_DEPENDENCIES = libpng libjpeg freetype alsa-lib fdk-aac speexdsp ipc-sqe
IPC_SDK_DEPENDENCIES += aml-libge2d aml-libgdc aml-libion linux libfuse
IPC_SDK_DEPENDENCIES += libgpiod

IPC_SDK_CFLAGS := $(TARGET_CFLAGS)
ifeq ($(BR2_PACKAGE_AML_SOC_USE_MULTIENC), y)
IPC_SDK_DEPENDENCIES += libmultienc
else
IPC_SDK_CFLAGS += -DIPC_SDK_VENC_LEGACY
IPC_SDK_DEPENDENCIES += libvpcodec libvphevcodec
endif

ifeq ($(BR2_PACKAGE_IPC_SDK_BUILD_V4L_DEC), y)
IPC_SDK_CFLAGS += -DIPC_SDK_HAS_VDEC
endif

ifeq ($(BR2_PACKAGE_IPC_SDK_BUILD_VO_EGL), y)
IPC_SDK_CFLAGS += -DIPC_SDK_HAS_VO_EGL
IPC_SDK_DEPENDENCIES += libdrm meson-mali
endif

IPC_SDK_CFLAGS += -DIPC_SDK_HAS_FUSE_DEBUG

ifeq ($(BR2_PACKAGE_IPC_SDK_BUILD_EXAMPLE), y)
IPC_SDK_DEPENDENCIES += gstreamer1 gst1-rtsp-server gst1-plugins-base libwebsockets aml-nn-detect
endif

IPC_SDK_GIT_VERSION=$(shell \
			if [ -d $(IPC_SDK_SITE)/.git ]; then \
			   git -C $(IPC_SDK_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define IPC_SDK_BUILD_CMDS
	REVISION=$(IPC_SDK_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(IPC_SDK_CFLAGS)" $(MAKE) -C $(@D)
endef

define IPC_SDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/src/libaml_ipc_sdk.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/inc/* $(STAGING_DIR)/usr/include/
endef

define IPC_SDK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/src/libaml_ipc_sdk.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/example/ipc_launch $(TARGET_DIR)/usr/bin/
endef

IPC_SDK_EXTRA_BUILD :=

ifeq ($(BR2_PACKAGE_IPC_SDK_BUILD_EXAMPLE), y)
	IPC_SDK_EXTRA_BUILD += IPC_SDK_BUILD_EXAMPLE="y"
else
define IPC_SDK_BUILD_IPC_LAUNCH
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(IPC_SDK_CFLAGS)" $(MAKE) -C $(@D) example/ipc_launch
endef
IPC_SDK_POST_INSTALL_STAGING_HOOKS += IPC_SDK_BUILD_IPC_LAUNCH
endif

define IPC_SDK_BUILD_EXTRA
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(IPC_SDK_EXTRA_BUILD) CFLAGS="$(IPC_SDK_CFLAGS)" $(MAKE) -C $(@D)
endef

define IPC_SDK_RELEASE_PACKAGE
	tar czf $(TARGET_DIR)/../images/ipc-sdk-prebuilt.tgz \
		-C $(@D) \
		--transform "s@^\.@$(IPC_SDK_PLATFORM)@" \
		--exclude="*.o" --exclude="*.d" --exclude='.[^/]*' --exclude='objs' \
		./inc \
		./src/libaml_ipc_sdk.so \
		./example \
		./makefile.inc
endef

ifneq ($(IPC_SDK_EXTRA_BUILD), '')
IPC_SDK_POST_INSTALL_STAGING_HOOKS += IPC_SDK_BUILD_EXTRA
endif
IPC_SDK_POST_INSTALL_STAGING_HOOKS += IPC_SDK_RELEASE_PACKAGE
else #prebuilt
IPC_SDK_SITE = $(IPC_SDK_LOCAL_PREBUILT)

define IPC_SDK_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/$(IPC_SDK_PLATFORM)/src/libaml_ipc_sdk.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/$(IPC_SDK_PLATFORM)/inc/* $(STAGING_DIR)/usr/include/
endef

define IPC_SDK_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/$(IPC_SDK_PLATFORM)/src/libaml_ipc_sdk.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/$(IPC_SDK_PLATFORM)/example/ipc_launch $(TARGET_DIR)/usr/bin/
endef
endif #prebuilt

$(eval $(generic-package))
