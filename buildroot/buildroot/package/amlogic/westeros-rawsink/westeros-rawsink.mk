################################################################################
#
# westeros-rawsink
#
################################################################################

WESTEROS_RAWSINK_VERSION = 607510644c10059271c389e345fe9d4fe9bddfed
WESTEROS_RAWSINK_SITE_METHOD = git
WESTEROS_RAWSINK_SITE = git://github.com/rdkcmf/westeros
WESTEROS_RAWSINK_INSTALL_STAGING = YES
WESTEROS_RAWSINK_AUTORECONF = YES
WESTEROS_RAWSINK_AUTORECONF_OPTS = "-Icfg"

WESTEROS_RAWSINK_DEPENDENCIES = host-pkgconf host-autoconf westeros libegl libdrm
# Add dependency to linux, because we need some header files installed by linux
WESTEROS_RAWSINK_DEPENDENCIES += linux

WESTEROS_RAWSINK_CONF_OPTS += \
	--prefix=/usr/ \
    --disable-silent-rules \
    --disable-dependency-tracking \

WESTEROS_RAWSINK_SUBDIR = westeros-sink/raw
WESTEROS_RAWSINK_DEPENDENCIES += gstreamer1
WESTEROS_RAWSINK_CONF_OPTS += --enable-gstreamer1=yes \
	CFLAGS="$(TARGET_CFLAGS) -DUSE_AMLOGIC_MESON -I${STAGING_DIR}/usr/include/libdrm -x c++" \
	CXXFLAGS="$(TARGET_CXXFLAGS) -DUSE_AMLOGIC_MESON -I${STAGING_DIR}/usr/include/libdrm "
WESTEROS_RAWSINK_MAKE_ENV += PKG_CONFIG_SYSROOT_DIR=${STAGING_DIR}
WESTEROS_RAWSINK_MAKE_ENV += STAGING_INCDIR=${STAGING_DIR}/usr/include

define WESTEROS_RAWSINK_RUN_AUTOCONF
	mkdir -p $(@D)/$(WESTEROS_RAWSINK_SUBDIR)/cfg
	mkdir -p $(@D)/$(WESTEROS_RAWSINK_SUBDIR)/m4
endef
WESTEROS_RAWSINK_PRE_CONFIGURE_HOOKS += WESTEROS_RAWSINK_RUN_AUTOCONF

define WESTEROS_RAWSINK_ENTER_BUILD_DIR
	cd $(@D)/$(WESTEROS_RAWSINK_SUBDIR) && ln -sf ../../westeros-sink/westeros-sink.c && ln -sf ../../westeros-sink/westeros-sink.h
endef
WESTEROS_RAWSINK_PRE_BUILD_HOOKS += WESTEROS_RAWSINK_ENTER_BUILD_DIR

$(eval $(autotools-package))
