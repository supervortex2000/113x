################################################################################
#
# log4c
#
################################################################################

LOG4C_VERSION = 1.2.4
LOG4C_SOURCE = log4c-$(LOG4C_VERSION).tar.gz
LOG4C_SITE =   https://sourceforge.net/projects/log4c/files/log4c/$(LOG4C_VERSION)
LOG4C_INSTALL_STAGING = YES
LOG4C_CONF_OPTS = --disable-expattest
LOG4C_DEPENDENCIES = expat
LOG4C_CONFIG_SCRIPTS = log4c-config
LOG4C_LICENSE = LGPL-2.1
LOG4C_LICENSE_FILES = COPYING
LOG4C_AUTORECONF = YES

define LOG4C_FIX_CONFIGURE_PERMS
	chmod +x $(@D)/configure
endef

LOG4C_PRE_CONFIGURE_HOOKS += LIBLOG4C_LOCALTIME_FIX_CONFIGURE_PERMS

$(eval $(autotools-package))
