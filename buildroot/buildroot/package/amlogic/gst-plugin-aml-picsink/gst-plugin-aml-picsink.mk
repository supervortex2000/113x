#############################################################
#
# gst-plugin-aml-picsink
#
#############################################################
GST_PLUGIN_AML_PICSINK_VERSION = 1.0
GST_PLUGIN_AML_PICSINK_SITE = $(TOPDIR)/../multimedia/gst-plugin-aml-picsink
GST_PLUGIN_AML_PICSINK_SITE_METHOD = local

GST_PLUGIN_AML_PICSINK_INSTALL_STAGING = YES
GST_PLUGIN_AML_PICSINK_AUTORECONF = YES
GST_PLUGIN_AML_PICSINK_DEPENDENCIES = gstreamer1 gst1-plugins-base host-pkgconf speexdsp libdrm libdrm-meson

$(eval $(autotools-package))

