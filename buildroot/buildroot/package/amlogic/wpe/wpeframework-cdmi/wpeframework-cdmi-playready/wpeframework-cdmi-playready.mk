################################################################################
#
# wpeframework-cdmi-playready
#
################################################################################
PLAYREADY_BIN_VERSION = $(call qstrip,$(BR2_PACKAGE_PLAYREADY_BIN_VERSION))
WPEFRAMEWORK_CDMI_PLAYREADY_VERSION = $(PLAYREADY_BIN_VERSION)
WPEFRAMEWORK_CDMI_PLAYREADY_SITE_METHOD = local
WPEFRAMEWORK_CDMI_PLAYREADY_PREBUILD_DIR = $(TOPDIR)/../multimedia/libmediadrm/playready-bin/prebuilt-v$(PLAYREADY_BIN_VERSION)/wpeframework-cdmi
WPEFRAMEWORK_CDMI_PLAYREADY_SITE = $(WPEFRAMEWORK_CDMI_PLAYREADY_PREBUILD_DIR)
WPEFRAMEWORK_CDMI_PLAYREADY_INSTALL_STAGING = NO

PLAYREADY_DRM_PREBUILT_DIRECTORY = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_PLAYREADY_BUILDALL),y)
WPEFRAMEWORK_CDMI_PLAYREADY_SITE = $(TOPDIR)/../multimedia/libmediadrm/OCDM-playready-amlogic
endif
WPEFRAMEWORK_CDMI_PLAYREADY_DEPENDENCIES = wpeframework playready-bin

WPEFRAMEWORK_CDMI_PLAYREADY_CONF_OPTS = -DPERSISTENT_PATH=${BR2_PACKAGE_WPEFRAMEWORK_PERSISTENT_PATH} \
                                        -DNETFLIX_EXTENSION=OFF

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_PLAYREADY_BUILDALL),y)

define WPEFRAMEWORK_CDMI_PLAYREADY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/WPEFramework/OCDM
	install -m 0644 $(WPEFRAMEWORK_CDMI_PLAYREADY_DIR)/$(PLAYREADY_DRM_PREBUILT_DIRECTORY)/Playready.drm \
		$(TARGET_DIR)/usr/share/WPEFramework/OCDM
	mkdir -p $(TARGET_DIR)/root/OCDM
	ln -fs /etc/playready $(TARGET_DIR)/root/OCDM/playready
endef

else
define COPY_LIBRARY_TO_PREBUILD
	tar -zcf $(TARGET_DIR)/../images/prebuild-$(PLAYREADY_DRM_PREBUILT_DIRECTORY).Playready.drm.tgz \
		$(TARGET_DIR)/usr/share/WPEFramework/OCDM/Playready.drm
endef

WPEFRAMEWORK_CDMI_PLAYREADY_POST_INSTALL_TARGET_HOOKS += COPY_LIBRARY_TO_PREBUILD
endif

$(eval $(cmake-package))
