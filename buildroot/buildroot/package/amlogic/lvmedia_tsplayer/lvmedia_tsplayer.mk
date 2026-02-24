#
# lvmedia_tsplayer1.0 mod by private
#
ifeq ($(BR2_PACKAGE_LVMEDIA_TSPLAYER), y)

LVMEDIA_TSPLAYER_VERSION = 1.0
LVMEDIA_TSPLAYER_SITE = $(TOPDIR)/../vendor/amlogic/lvmedia_tsplayer
LVMEDIA_TSPLAYER_SITE_METHOD = local
LVMEDIA_TSPLAYER_INSTALL_STAGING = YES
LVMEDIA_TSPLAYER_DEPENDENCIES = mediahal-sdk lvmediasdk ffmpeg

$(eval $(cmake-package))
endif
