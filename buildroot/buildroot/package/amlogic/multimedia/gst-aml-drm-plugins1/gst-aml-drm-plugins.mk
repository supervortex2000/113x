#############################################################
#
# gat-aml-drm-plugins1
#
#############################################################
GST_AML_DRM_PLUGINS1_VERSION = 1.0
GST_AML_DRM_PLUGINS1_SITE = $(TOPDIR)/../multimedia/gst-aml-drm-plugins1/gst-aml-drm-plugins-1.0
GST_AML_DRM_PLUGINS1_SITE_METHOD = local

GST_AML_DRM_PLUGINS1_INSTALL_STAGING = YES
GST_AML_DRM_PLUGINS1_AUTORECONF = YES
GST_AML_DRM_PLUGINS1_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-bad host-pkgconf \
				host-patchelf

ifneq ($(BR2_PACKAGE_LIBSECMEM),y)
GST_AML_DRM_PLUGINS1_DEPENDENCIES  += libsecmem-bin
else
GST_AML_DRM_PLUGINS1_DEPENDENCIES  += libsecmem
endif

ifneq ($(BR2_PACKAGE_CLEARTVP),y)
GST_AML_DRM_PLUGINS1_DEPENDENCIES  += cleartvp-bin
else
GST_AML_DRM_PLUGINS1_DEPENDENCIES  += cleartvp
endif

define GST_AML_DRM_PLUGINS1_FIX_RPATH
	$(HOST_DIR)/bin/patchelf --set-rpath /usr/lib/gstreamer-1.0 \
		$(TARGET_DIR)/usr/lib/gstreamer-1.0/libgstamlsecparse.so
endef
GST_AML_DRM_PLUGINS1_POST_INSTALL_TARGET_HOOKS += GST_AML_DRM_PLUGINS1_FIX_RPATH


define GST_AML_DRM_PLUGINS1_INSTALL_STAGING_CMDS
	install -d $(STAGING_DIR)/usr/include
	install -m 0644 $(@D)/src/secmem/gstsecmemallocator.h $(STAGING_DIR)/usr/include
	install -d $(STAGING_DIR)/usr/lib
	install -m 0755 $(@D)/src/secmem/.libs/libgstsecmemallocator.so*  $(STAGING_DIR)/usr/lib
	install -m 0755 $(@D)/src/dummy/.libs/libgstdummydrm.so $(STAGING_DIR)/usr/lib

endef
$(eval $(autotools-package))

