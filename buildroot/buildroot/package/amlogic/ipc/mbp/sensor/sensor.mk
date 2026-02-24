#############################################################
#
# sensor
#
#############################################################

SENSOR_VERSION = 1.0
SENSOR_SITE_METHOD = local
SENSOR_INSTALL_STAGING = YES
SENSOR_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/sensor
SENSOR_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd)
SENSOR_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/sensor
SENSOR_TMP = $(TOPDIR)/../output/sensor-tmp
SENSOR_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/sensor/sensor.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

SENSOR_DEPENDENCIES = mbd-base mbd-camera linux-osal

ifneq ($(BR2_PACKAGE_FDK_AAC), )
SENSOR_DEPENDENCIES += fdk-aac
endif

ifneq ($(BR2_PACKAGE_SPEEXDSP), )
SENSOR_DEPENDENCIES += speexdsp
endif
SENSOR_CFLAGS := $(TARGET_CFLAGS)

SENSOR_GIT_VERSION=$(shell \
			if [ -d $(SENSOR_SITE)/.git ]; then \
			   git -C $(SENSOR_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define SENSOR_RELEASE_PACKAGE
	-mkdir -p $(SENSOR_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(SENSOR_TMP); \
		fi; \
	done < $(@D)/sensor.filelist

	-tar --transform 's,^,sensor/,S' \
	-czf $(TARGET_DIR)/../images/ipc-sensor-prebuilt.tgz \
	-C $(SENSOR_TMP)/$(@D) .
	-rm -rf $(SENSOR_TMP)
endef
define SENSOR_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "SENSOR: LACK of prebuilt release filelist!"
endef

ifneq ($(SENSOR_LOCAL_SRC),)
SENSOR_CFLAGS += \
	-I$(LINUX_OSAL_DIR)/include \
	-I$(MBD_BASE_DIR)/include \
	-I$(MBD_BASE_DIR)/vbp/include \
	-I$(MBD_BASE_DIR)/sys/include \
	-I$(MBD_BASE_DIR)/cppi/include \
	-I$(MBD_BASE_DIR)/log/include \
	-I$(MBD_BASE_DIR)/dummy/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/base/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera/vi/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbi/isp/include \
	-I$(PMZ_DIR)/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera/vi/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera/isp/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/mbd/camera/mipi_rx/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/osal/linux/include  	\
	-Wno-unused-variable \
	-U_FORTIFY_SOURCE \
	-Wno-unused-function
else # prebuilt
SENSOR_CFLAGS += \
	-I$(LINUX_OSAL_DIR)/include \
	-I$(MBD_BASE_DIR)/include \
	-I$(MBD_BASE_DIR)/vbp/include \
	-I$(MBD_BASE_DIR)/sys/include \
	-I$(MBD_BASE_DIR)/cppi/include \
	-I$(MBD_BASE_DIR)/log/include \
	-I$(MBD_BASE_DIR)/dummy/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/base/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/camera/vi/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbi/isp/include \
	-I$(PMZ_DIR)/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/camera/vi/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/camera/isp/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbd/camera/mipi_rx/include \
	-I$(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/osal/linux/include \
	-Wno-unused-variable \
	-U_FORTIFY_SOURCE \
	-Wno-unused-function
endif

SENSOR_SAMPLE_MAKE_ENV = \
    $(TARGET_MAKE_ENV) \
    CFLAGS="$(SENSOR_CFLAGS)" \
    SENSOR_LIBA_DIR=$(MBI_DIR)
ifeq ($(BR2_ARM_KERNEL_64)$(BR2_arm),yy)
    SENSOR_CFLAGS  += -DUSER_32_KERNEL_64
endif

ifneq ($(SENSOR_LOCAL_SRC),)
SENSOR_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/sensor
ifneq ($(SENSOR_FILELIST),)
SENSOR_POST_INSTALL_STAGING_HOOKS += SENSOR_RELEASE_PACKAGE
else
SENSOR_POST_INSTALL_STAGING_HOOKS += SENSOR_LACK_WARNING
endif

define SENSOR_BUILD_CMDS
	REVISION=$(SENSOR_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(SENSOR_CFLAGS)" $(MAKE) -C $(@D)
endef

define SENSOR_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/*/*.so $(STAGING_DIR)/usr/lib/
endef

define SENSOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/*/*.so $(TARGET_DIR)/usr/lib/
endef
else # prebuilt
SENSOR_SITE = $(SENSOR_LOCAL_PREBUILT)

define SENSOR_BUILD_CMDS
	REVISION=$(SENSOR_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(SENSOR_CFLAGS)" $(MAKE) -C $(@D)
endef

define SENSOR_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/*/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/*/*.a $(STAGING_DIR)/usr/lib/
endef

define SENSOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/*/*.so $(TARGET_DIR)/usr/lib/
endef

endif


$(eval $(generic-package))
