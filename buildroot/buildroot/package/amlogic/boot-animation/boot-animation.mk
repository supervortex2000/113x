#
# boot-animation
#
BOOT_ANIMATION_VERSION = 1.0
BOOT_ANIMATION_SITE = $(TOPDIR)/../vendor/amlogic/boot-animation
BOOT_ANIMATION_SITE_METHOD = local
BOOT_ANIMATION_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad gst1-libav gst1-plugins-tsplayer

define BOOT_ANIMATION_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" -C $(@D) all
endef

define BOOT_ANIMATION_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/boot-animation $(TARGET_DIR)/usr/bin/boot-animation
    $(INSTALL) -D -m 0755 $(@D)/boot-animation-player $(TARGET_DIR)/usr/bin/boot-animation-player
    cp $(BOOT_ANIMATION_PKGDIR)/boot-animation.mp4 $(TARGET_DIR)/media
    chmod 755 $(BOOT_ANIMATION_PKGDIR)/S00bootanimation
    cp $(BOOT_ANIMATION_PKGDIR)/S00bootanimation $(TARGET_DIR)/etc/init.d
endef

define BOOT_ANIMATION_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
