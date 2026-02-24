#####################################################################################
#
#libpeer
#
####################################################################################

LIBPEER_SITE = $(BR2_PACKAGE_LIBPEER_SITE)
LIBPEER_SITE_METHOD = local
LIBPEER_LICENSE = Apache License 2.0
LIBPEER_LICENSE = LICENSE
LIBPEER_INSTALL_STAGING = YES


LIBPEER_CONF_OPTS = -DCMAKE_BUILD_TYPE=RELEASE

$(eval $(cmake-package))
