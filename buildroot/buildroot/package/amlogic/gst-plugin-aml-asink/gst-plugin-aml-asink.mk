#############################################################
#
# gat-plugin-aml-asink
#
#############################################################
GST_PLUGIN_AML_ASINK_VERSION = 1.0
GST_PLUGIN_AML_ASINK_SITE = $(TOPDIR)/../multimedia/gst-plugin-aml-asink
GST_PLUGIN_AML_ASINK_SITE_METHOD = local

GST_PLUGIN_AML_ASINK_INSTALL_STAGING = YES
GST_PLUGIN_AML_ASINK_AUTORECONF = YES
GST_PLUGIN_AML_ASINK_DEPENDENCIES = gstreamer1 gst1-plugins-base host-pkgconf hal-audio-service

ifeq ($(BR2_PACKAGE_GST_PLUGIN_AML_ASINK_XRUN),y)
GST_PLUGIN_AML_ASINK_CONF_OPTS += --enable-xrun-detection=yes
endif

$(eval $(autotools-package))

