################################################################################
#
#video_algorithm driver
#
################################################################################
VIDEO_ALGORITHM_SITE = $(TOPDIR)/../vendor/amlogic/video_algorithm
VIDEO_ALGORITHM_SITE_METHOD = local
VIDEO_ALGORITHM_DEPENDENCIES = linux

VIDEO_ALGORITHM_KO_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/video_algorithm
VIDEO_ALGORITHM_KO_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
VIDEO_ALGORITHM_KO_MODULE_DIR := kernel/video_algorithm

KERNEL_VERSION = $(call qstrip,$(BR2_LINUX_KERNEL_CUSTOM_LOCAL_VERSION_VALUE))
VIDEO_ALGORITHM_KO_VERSION = $(shell echo $(KERNEL_VERSION) | cut -d'-' -f2)

ifeq ($(BR2_ARM_KERNEL_32),y)
	KERNEL_BITS = 32
else
	KERNEL_BITS = 64
endif

define copy-algorithm-modules
	$(foreach m, $(shell find $(strip $(1)) -name "*$(KERNEL_BITS).ko"),\
		$(shell [ ! -e $(2) ] && mkdir $(2) -p;\
		cp $(m) $(strip $(2))/$(subst _$(KERNEL_BITS),,$(notdir $(m))) -rfa;\
		echo $(4)/$(subst _$(KERNEL_BITS),,$(notdir $(m))): >> $(3)))
endef

ifeq ($(BR2_PACKAGE_VIDEO_ALGORITHM_DNLP),y)
define VIDEO_ALGORITHM_DNLP_INSTALL_TARGET_CMDS
	$(call copy-algorithm-modules,$(@D)/$(VIDEO_ALGORITHM_KO_VERSION)/dnlp,\
		$(shell echo $(VIDEO_ALGORITHM_KO_INSTALL_DIR)),\
		$(shell echo $(VIDEO_ALGORITHM_KO_DEP)),\
		$(VIDEO_ALGORITHM_KO_MODULE_DIR))
endef
endif

ifeq ($(BR2_PACKAGE_VIDEO_ALGORITHM_DHR10_TMO),y)
define VIDEO_ALGORITHM_DHR10_TMO_INSTALL_TARGET_CMDS
	$(call copy-algorithm-modules,$(@D)/$(VIDEO_ALGORITHM_KO_VERSION)/hdr10_tmo,\
		$(shell echo $(VIDEO_ALGORITHM_KO_INSTALL_DIR)),\
		$(shell echo $(VIDEO_ALGORITHM_KO_DEP)),\
		$(VIDEO_ALGORITHM_KO_MODULE_DIR))
endef
endif

ifeq ($(BR2_PACKAGE_VIDEO_ALGORITHM_CABC_AAD),y)
define VIDEO_ALGORITHM_CABC_AAD_INSTALL_TARGET_CMDS
	$(call copy-algorithm-modules,$(@D)/$(VIDEO_ALGORITHM_KO_VERSION)/cabc_aad,\
		$(shell echo $(VIDEO_ALGORITHM_KO_INSTALL_DIR)),\
		$(shell echo $(VIDEO_ALGORITHM_KO_DEP)),\
		$(VIDEO_ALGORITHM_KO_MODULE_DIR))
endef
endif

ifeq ($(BR2_PACKAGE_VIDEO_ALGORITHM_LDIM),y)
define VIDEO_ALGORITHM_LDIM_INSTALL_TARGET_CMDS
	$(call copy-algorithm-modules,$(@D)/$(VIDEO_ALGORITHM_KO_VERSION)/ldim,\
		$(shell echo $(VIDEO_ALGORITHM_KO_INSTALL_DIR)),\
		$(shell echo $(VIDEO_ALGORITHM_KO_DEP)),\
		$(VIDEO_ALGORITHM_KO_MODULE_DIR))
endef
endif

define VIDEO_ALGORITHM_INSTALL_TARGET_CMDS
	$(VIDEO_ALGORITHM_DNLP_INSTALL_TARGET_CMDS)
	$(VIDEO_ALGORITHM_DHR10_TMO_INSTALL_TARGET_CMDS)
	$(VIDEO_ALGORITHM_CABC_AAD_INSTALL_TARGET_CMDS)
	$(VIDEO_ALGORITHM_LDIM_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
