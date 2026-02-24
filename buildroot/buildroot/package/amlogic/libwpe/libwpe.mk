################################################################################
#
# libwpe
#
################################################################################

LIBWPE_VERSION = 4be4c7df5734d125148367a90da477c8d40d9eaf
LIBWPE_SITE = git://github.com/WebPlatformForEmbedded/WPEBackend.git

LIBWPE_INSTALL_STAGING = YES

LIBWPE_DEPENDENCIES += libegl libxkbcommon

LIBWPE_C_FLAGS = "-D_GNU_SOURCE"
LIBWPE_CONF_OPTS += -DWPE_BACKEND=libWPEBackend-default.so -DCMAKE_C_FLAGS=$(LIBWPE_C_FLAGS)

$(eval $(cmake-package))
