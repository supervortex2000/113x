#############################################################
#
# gat-plugin-aml-vsink
#
#############################################################
GST_PLUGIN_AML_VSINK_VERSION = 1.0
GST_PLUGIN_AML_VSINK_SITE = $(TOPDIR)/../multimedia/gst-plugin-aml-vsink
GST_PLUGIN_AML_VSINK_SITE_METHOD = local

GST_PLUGIN_AML_VSINK_INSTALL_STAGING = YES
GST_PLUGIN_AML_VSINK_AUTORECONF = YES
GST_PLUGIN_AML_VSINK_DEPENDENCIES = gstreamer1 gst1-plugins-base avsync-lib libdrm libdrm-meson gst-plugin-aml-asink

$(eval $(autotools-package))

