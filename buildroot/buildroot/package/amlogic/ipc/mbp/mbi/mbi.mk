#############################################################
#
# mbi
#
#############################################################

MBI_VERSION = 1.0
MBI_SITE_METHOD = local
MBI_INSTALL_STAGING = YES
MBI_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbi)
MBI_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/mbp/prebuilt/mbi
MBI_TMP = $(TOPDIR)/../output/mbi-tmp
MBI_FILELIST = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/mbp/mbi/*/mbi*.filelist)

ifneq ($(BR2_PACKAGE_AML_SOC_FAMILY_NAME), "")
IPC_SDK_SOC_FAMILY_NAME = $(strip $(BR2_PACKAGE_AML_SOC_FAMILY_NAME))/
endif
IPC_SDK_PLATFORM = $(IPC_SDK_SOC_FAMILY_NAME)$(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

MBI_DEPENDENCIES = mbd-base pmz mbd-cve mbd-ge2d mbd-region mbd-venc mbd-vpu mbd-adla mbd-dewarp mbd-camera mbd-audio mbd-ppu

ifneq ($(MBI_LOCAL_SRC),)
MBI_SITE = $(MBI_LOCAL_SRC)
MBI_CFLAGS := $(TARGET_CFLAGS)

MBI_GIT_VERSION=$(shell \
			if [ -d $(MBI_SITE)/.git ]; then \
			   git -C $(MBI_SITE) describe --abbrev=8 --dirty --always --tags; \
			else \
			   echo "unknown"; \
			fi)
MBI_CFLAGS = \
    -I$(LINUX_OSAL_DIR)/include \
    -I$(MBD_BASE_DIR)/include \
    -I$(MBD_BASE_DIR)/vbp/include \
    -I$(MBD_BASE_DIR)/sys/include \
    -I$(MBD_BASE_DIR)/cppi/include \
    -I$(MBD_BASE_DIR)/log/include \
    -I$(MBD_BASE_DIR)/dummy/include \
    -I$(PMZ_DIR)/include \
    -I$(MBD_CVE_DIR)/include\
    -I$(MBD_GE2D_DIR)/include \
    -I$(MBD_AUDIO_DIR)/include \
    -I$(MBD_REGION_DIR)/include \
    -I$(MBD_VENC_DIR)/include \
    -I$(MBD_VENC_DIR)/vce \
    -I$(MBD_VPU_DIR)/include  \
    -I$(MBD_ADLA_DIR)/include \
    -I$(MBD_DEWARP_DIR)/include \
    -I$(MBD_CAMERA_DIR)/isp/include \
    -I$(MBD_CAMERA_DIR)/mipi_rx/include \
    -I$(MBD_CAMERA_DIR)/vi/include \
    -I$(MBD_CAMERA_DIR)/mipi_rx2/include \
    -I$(MBD_CAMERA_DIR)/vi2/include \
    -I$(MBD_PPU_DIR)/include \
    -I$(@D)/mbi_base/include	\
    -I$(@D)/dewarp/include	\
    -I$(@D)/ppu/include

define MBI_RELEASE_PACKAGE
	-mkdir -p $(MBI_TMP)
	-touch $(@D)/mbi.filelist
	-count=$(shell find $(@D) -mindepth 2 -type f -name "*.filelist" | wc -l); \
	if [ $$count -lt 7 ];then \
		let diff=7-$$count; \
		printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBI: 7 mbi-filelists in total, LACK $$diff mbi-prebuilt release filelist!"; \
	fi
	-find $(@D) -mindepth 2 -type f -name "*.filelist" -exec cat {} > $(@D)/mbi.filelist \;
	-while read line;do \
		if [ -z $$line ];then \
			echo "blank line"; \
		else \
			echo $$line; \
			fullPath=$(@D)/$$line; \
			echo $$fullPath; \
			cp --parents -af $$fullPath $(MBI_TMP); \
		fi; \
	done < $(@D)/mbi.filelist
	-rm $(@D)/mbi.filelist

	-tar --transform 's,^,mbi/,S' \
	-czf $(TARGET_DIR)/../images/ipc-mbi-prebuilt.tgz \
	-C $(MBI_TMP)/$(@D) .
	-rm -rf $(MBI_TMP)
endef
define MBI_LACK_WARNING
		@printf '\033[1;33;40m[WARNING]  %b\033[0m\n' "MBI: LACK of prebuilt release filelist!"
endef

MBI_SAMPLE_MAKE_ENV = \
    $(TARGET_MAKE_ENV) \
    CFLAGS="$(MBI_CFLAGS)" \
    MBI_LIBA_DIR=$(MBI_DIR)
ifeq ($(BR2_ARM_KERNEL_64)$(BR2_arm),yy)
    MBI_CFLAGS  += -DUSER_32_KERNEL_64
endif

define MBI_BUILD_CMDS
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/mbi_base
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/venc
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/cve
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/adla
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/dewarp
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/isp
	REVISION=$(MBI_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) CFLAGS="$(MBI_CFLAGS)" $(MAKE) -C $(@D)/ppu
endef


define MBI_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/mbi_base/libmbi.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/mbi_base/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/venc/libmbi_venc.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/venc/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/cve/libmbi_cve.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/lib32/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/adla/libmbi_adla.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/dewarp/libmbi_dewarp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/library/libdewarp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/isp/libmbi_isp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/isp/lib/*/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ppu/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/ppu/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/audio_process/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/audio_process/aml_audio_signal_process.h $(STAGING_DIR)/usr/include
endef

define MBI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/mbi_base/libmbi.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/venc/libmbi_venc.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/lib32/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(STAGING_DIR)/usr/lib/libgomp.so.1 $(TARGET_DIR)/usr/lib/
	@cp $(@D)/cve/cva/lfdt $(TARGET_DIR)/etc -rf
	@cp $(@D)/cve/cva/psfd $(TARGET_DIR)/etc -rf
	@cp $(@D)/cve/cva/lpdr $(TARGET_DIR)/etc -rf
	$(INSTALL) -D -m 755 $(@D)/cve/libmbi_cve.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/libmbi_adla.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/lib/32/libadla.so $(TARGET_DIR)/usr/lib/
    $(INSTALL) -D -m 644 $(@D)/adla/lib/32/libnnsdk.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/libmbi_dewarp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/library/libdewarp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/libmbi_isp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/lib/*/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ppu/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/audio_process/*.so $(TARGET_DIR)/usr/lib/
endef

ifneq ($(MBI_FILELIST),)
MBI_POST_INSTALL_STAGING_HOOKS += MBI_RELEASE_PACKAGE
else
MBI_POST_INSTALL_STAGING_HOOKS += MBI_LACK_WARNING
endif

else # prebuilt
MBI_SITE = $(MBI_LOCAL_PREBUILT)

define MBI_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/mbi_base/libmbi.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/mbi_base/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/venc/libmbi_venc.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/venc/libmbi_venc.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/venc/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/cve/libmbi_cve.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/lib32/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/adla/libmbi_adla.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/libmbi_adla.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/lib/32/libadla.so $(STAGING_DIR)/usr/lib/
    $(INSTALL) -D -m 644 $(@D)/adla/lib/32/libnnsdk.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/lib/32/libadla.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/dewarp/libmbi_dewarp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/library/libdewarp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/isp/libmbi_isp.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/isp/lib/*/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/mbi_base/libmbi.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/libmbi_cve.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/libmbi_dewarp.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/library/libdewarp.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/libmbi_isp.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/lib/*/*.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ppu/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/ppu/include/* $(STAGING_DIR)/usr/include/
	$(INSTALL) -D -m 644 $(@D)/audio_process/*.so $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/audio_process/aml_audio_signal_process.h $(STAGING_DIR)/usr/include
endef

define MBI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/mbi_base/libmbi.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/venc/libmbi_venc.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/cve/cva/lib32/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(STAGING_DIR)/usr/lib/libgomp.so.1 $(TARGET_DIR)/usr/lib/
	@cp $(@D)/cve/cva/lfdt $(TARGET_DIR)/etc -rf
	@cp $(@D)/cve/cva/psfd $(TARGET_DIR)/etc -rf
	@cp $(@D)/cve/cva/lpdr $(TARGET_DIR)/etc -rf
	$(INSTALL) -D -m 755 $(@D)/cve/libmbi_cve.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/libmbi_adla.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/adla/lib/32/libadla.so $(TARGET_DIR)/usr/lib/
    $(INSTALL) -D -m 644 $(@D)/adla/lib/32/libnnsdk.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/libmbi_dewarp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/dewarp/library/libdewarp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/libmbi_isp.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/isp/lib/*/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/ppu/*.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 644 $(@D)/audio_process/*.so $(TARGET_DIR)/usr/lib/
endef
endif

$(eval $(generic-package))
