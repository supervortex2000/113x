#############################################################
#
# mbp sample
#
#############################################################

SAMPLE_VERSION = 1.0
SAMPLE_SITE_METHOD = local
SAMPLE_INSTALL_STAGING = YES
SAMPLE_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/sample)
SAMPLE_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/sample
SAMPLE_TMP = $(TOPDIR)/../output/sample-tmp
SAMPLE_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/sample/sample.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

SAMPLE_DEPENDENCIES = mbi sensor tool

ifneq ($(BR2_PACKAGE_FDK_AAC), )
SAMPLE_DEPENDENCIES += fdk-aac
endif

ifneq ($(BR2_PACKAGE_SPEEXDSP), )
SAMPLE_DEPENDENCIES += speexdsp
endif

SAMPLE_CFLAGS := $(TARGET_CFLAGS)

SAMPLE_GIT_VERSION=$(shell \
			if [ -d $(SAMPLE_SITE)/.git ]; then \
			   git -C $(SAMPLE_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)

define SAMPLE_RELEASE_PACKAGE
	-mkdir -p $(SAMPLE_TMP)
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(SAMPLE_TMP); \
		fi; \
	done < $(@D)/sample.filelist

	-tar --transform 's,^,sample/,S' \
	-czf $(TARGET_DIR)/../images/ipc-sample-prebuilt.tgz \
	-C $(SAMPLE_TMP)/$(@D) .
	-rm -rf $(SAMPLE_TMP)
endef
define SAMPLE_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "SAMPLE: LACK of prebuilt release filelist!"
endef

SAMPLE_CFLAGS = \
    -I$(SAMPLE_DIR)\
    -I$(SAMPLE_DIR)/pipeline_demo\
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
    -I$(MBD_CAMERA_DIR)/mipi_rx2/include \
    -I$(MBD_CAMERA_DIR)/vi2/include \
    -I$(MBD_PPU_DIR)/include \
    -I$(MBD_VPU_DIR)/include

SAMPLE_MAKE_ENV = \
    $(TARGET_MAKE_ENV) \
    CFLAGS="$(SAMPLE_CFLAGS)" \
    MBI_LIBA_DIR=$(MBI_DIR)	\
    TOOL_LIBA_DIR=$(TOOL_DIR) \
    SENSOR_LIBA_DIR=$(SENSOR_DIR)

ifneq ($(SAMPLE_LOCAL_SRC),)
SAMPLE_SITE = $(TOPDIR)/../vendor/amlogic/ipc/mbp/sample
ifneq ($(SAMPLE_FILELIST),)
SAMPLE_POST_INSTALL_STAGING_HOOKS += SAMPLE_RELEASE_PACKAGE
else
SAMPLE_POST_INSTALL_STAGING_HOOKS += SAMPLE_LACK_WARNING
endif

define SAMPLE_BUILD_CMDS
	REVISION=$(SAMPLE_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(SAMPLE_MAKE_ENV) CFLAGS="$(SAMPLE_CFLAGS)" $(MAKE) AAC_SUPPORT=$(BR2_PACKAGE_FDK_AAC) RESAMPLE_SUPPORT=$(BR2_PACKAGE_SPEEXDSP) -C $(@D)
endef

define SAMPLE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/sys/sample_sys $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/vbp/sample_vbp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/pmz/sample_pmz $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/log/sample_log $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/cve/sample_cve $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/vpu/sample_vpu $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/ge2d/sample_ge2d $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/region/sample_region $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/audio/sample_audio $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/venc/sample_venc $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/venc/cli/venc_cli $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/venc/slt/c3_slt_test $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/dewarp/sample_dewarp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/isp/sample_cam $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/tofsns_sample/tofsns_sample $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/tofsns_sample/tof_sensor.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla.adla $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla_input $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/pipeline_demo $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/doorbell_pipeline_demo $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/pipeline_demo_ext/libpipeline_demo_ext.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/amlogic_560_260.rgb $(TARGET_DIR)/etc/
	@cp $(@D)/pipeline_demo/pipelineCfg $(TARGET_DIR)/etc -rf
	@cp $(@D)/doorbell_pipeline_demo/pipelineCfg/* $(TARGET_DIR)/etc/pipelineCfg/ -rf
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/run_pipeline.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/load_mbd.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/run_doorbell_pipeline.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/audio/asp/libasp.so $(TARGET_DIR)/usr/lib
endef

else # prebuilt
SAMPLE_SITE = $(SAMPLE_LOCAL_PREBUILT)

define SAMPLE_BUILD_CMDS
	REVISION=$(SAMPLE_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(SAMPLE_MAKE_ENV) CFLAGS="$(SAMPLE_CFLAGS)" $(MAKE) AAC_SUPPORT=$(BR2_PACKAGE_FDK_AAC) RESAMPLE_SUPPORT=$(BR2_PACKAGE_SPEEXDSP) -C $(@D)
endef

define SAMPLE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/vbp/sample_vbp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/pmz/sample_pmz $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/log/sample_log $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/cve/sample_cve $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/vpu/sample_vpu $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/ge2d/sample_ge2d $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/region/sample_region $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/audio/sample_audio $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/venc/sample_venc $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/dewarp/sample_dewarp $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla.adla $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 755 $(@D)/adla/sample_adla_input $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/pipeline_demo $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/amlogic_560_260.rgb $(TARGET_DIR)/etc/
	@cp $(@D)/pipeline_demo/pipelineCfg $(TARGET_DIR)/etc -rf
	@cp $(@D)/doorbell_pipeline_demo/pipelineCfg/* $(TARGET_DIR)/etc/pipelineCfg/ -rf
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/run_pipeline.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/load_mbd.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/doorbell_pipeline_demo $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/pipeline_demo_ext/libpipeline_demo_ext.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 755 $(@D)/pipeline_demo/amlogic_560_260.rgb $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 755 $(@D)/doorbell_pipeline_demo/run_doorbell_pipeline.sh $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/audio/asp/libasp.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 755 $(@D)/tofsns_sample/tofsns_sample $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 755 $(@D)/tofsns_sample/tof_sensor.sh $(TARGET_DIR)/usr/bin
endef

endif

$(eval $(generic-package))
