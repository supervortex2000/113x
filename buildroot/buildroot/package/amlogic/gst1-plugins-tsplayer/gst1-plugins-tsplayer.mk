#############################################################
#
# gst1-plugins-tsplayer
#
#############################################################
GST1_PLUGINS_TSPLAYER_VERSION = 1.0
GST1_PLUGINS_TSPLAYER_SITE = $(TOPDIR)/../vendor/amlogic/gst1-plugins-tsplayer
GST1_PLUGINS_TSPLAYER_SITE_METHOD = local
GST1_PLUGINS_TSPLAYER_DEPENDENCIES = gstreamer1 gst1-plugins-base  gst1-plugins-bad mediahal-sdk

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_TSPLAYER_DEFAULT),y)
define GST1_PLUGINS_TSPLAYER_DEFAULT_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" -C $(@D) all
endef

define GST1_PLUGINS_TSPLAYER_DEFAULT_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/common/libmediasession.so $(TARGET_DIR)/usr/lib/
    $(INSTALL) -D -m 0755 $(@D)/video/libgstamltspvsink.so $(TARGET_DIR)/usr/lib/gstreamer-1.0/
    $(INSTALL) -D -m 0755 $(@D)/audio/libgstamltspasink.so $(TARGET_DIR)/usr/lib/gstreamer-1.0/
endef
endif


ifeq ($(BR2_PACKAGE_GST1_PLUGINS_TSPLAYER_TEST_TOOLS),y)
define GST1_PLUGINS_TSPLAYER_TEST_TOOLS_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CC) PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" -C $(@D)/tests all
endef

define GST1_PLUGINS_TSPLAYER_TEST_TOOLS_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/tests/gst_test $(TARGET_DIR)/usr/bin
endef
endif


define GST1_PLUGINS_TSPLAYER_BUILD_CMDS
    $(GST1_PLUGINS_TSPLAYER_DEFAULT_BUILD_CMDS)
    $(GST1_PLUGINS_TSPLAYER_TEST_TOOLS_BUILD_CMDS)
endef

define GST1_PLUGINS_TSPLAYER_INSTALL_TARGET_CMDS
    $(GST1_PLUGINS_TSPLAYER_DEFAULT_INSTALL_TARGET_CMDS)
    $(GST1_PLUGINS_TSPLAYER_TEST_TOOLS_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
