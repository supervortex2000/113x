#############################################################
#
# mbp cva
#
#############################################################

MBP_CVA_VERSION = 1.0
MBP_CVA_SITE_METHOD = local
MBP_CVA_INSTALL_STAGING = YES
MBP_CVA_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/cva

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

MBP_CVA_DEPENDENCIES = mbi

MBP_CVA_CFLAGS := $(TARGET_CFLAGS)

MBP_CVA_GIT_VERSION=$(shell \
			if [ -d $(MBP_CVA_SITE)/.git ]; then \
			   git -C $(MBP_CVA_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define MBP_CVA_RELEASE_PACKAGE
	-mkdir -p $(MBP_CVA_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBP_CVA_TMP); \
		fi; \
	done < $(@D)/cva.filelist

	-tar --transform 's,^,cva/,S' \
	-czf $(TARGET_DIR)/../images/ipc-cva-prebuilt.tgz \
	-C $(MBP_CVA_TMP)/$(@D) .
	-rm -rf $(MBP_CVA_TMP)
endef

MBP_CVA_CFLAGS = \
    -I$(MBP_CVA_DIR)/include \
    -I$(LINUX_OSAL_DIR)/include \
    -I$(MBD_BASE_DIR)/include \
    -I$(MBD_BASE_DIR)/cppi/include \
    -I$(MBI_DIR)/vbp/include \
    -I$(MBI_DIR)/isp/include \
    -I$(PMZ_DIR)/include \
    -I$(MBD_BASE_DIR)/dummy/include \
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
    -I$(MBD_VPU_DIR)/include

MBP_CVA_MAKE_ENV = \
    $(TARGET_MAKE_ENV) \
    CFLAGS="$(MBP_CVA_CFLAGS)" \
    MBI_LIBA_DIR=$(MBI_DIR)	\
    TOOL_LIBA_DIR=$(TOOL_DIR) \
    SENSOR_LIBA_DIR=$(SENSOR_DIR)


define MBP_CVA_BUILD_CMDS
	REVISION=$(MBP_CVA_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(MBP_CVA_MAKE_ENV) CFLAGS="$(MBP_CVA_CFLAGS)" $(MAKE) -C $(@D)
endef
define MBP_CVA_INSTALL_STAGING_CMDS
        $(INSTALL) -D -m 644 $(@D)/cad/libcva_cad.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cad/include/* $(STAGING_DIR)/usr/include/
endef

define MBP_CVA_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 644 $(@D)/cad/libcva_cad.so $(TARGET_DIR)/usr/lib/
endef



$(eval $(generic-package))
