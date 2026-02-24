#####################################################################################
#
#opensc
#
####################################################################################

OPENSC_SITE = $(BR2_PACKAGE_OPENSC_SITE)
OPENSC_SITE_METHOD = local
OPENSC_LICENSE = Apache License 2.0
OPENSC_LICENSE = LICENSE
OPENSC_INSTALL_STAGING = YES
OPENSC_DEPENDENCIES = openssl


$(eval $(autotools-package))
