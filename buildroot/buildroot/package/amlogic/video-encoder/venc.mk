################################################################################
#
# amlogic c3 video encoder drivers and usr librarys
#
################################################################################
ifeq ($(BR2_PACKAGE_C3_VIDEO_ENCODER_LOCAL),y)
#BR2_PACKAGE_C3_VIDEO_ENCODER_LOCAL_PATH=$(TOPDIR)/../hardware/aml-5.15/amlogic/video_encoder_c3
VENC_SITE = $(call qstrip,$(BR2_PACKAGE_C3_VIDEO_ENCODER_LOCAL_PATH))
VENC_SITE_METHOD = local
VENC_VERSION = 1.0
VENC_MODULE_DIR = kernel/amlogic/npu
VENC_KO_INSTALL_DIR=$(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/amlogic/venc
VENC_SO_INSTALL_DIR=$(TARGET_DIR)/usr/lib
VENC_DEPENDENCIES = linux
VENC_INSTALL_STAGING = YES
VENC_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
endif


