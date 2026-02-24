################################################################################
#
# audiocapturemgr
#
################################################################################

AUDIOCAPTUREMGR_VERSION = stable2
AUDIOCAPTUREMGR_SITE_METHOD = git
AUDIOCAPTUREMGR_SITE = ssh://gerrit.teamccp.com:29418/rdk/components/generic/audiocapturemgr/generic
AUDIOCAPTUREMGR_AUTORECONF = YES
AUDIOCAPTUREMGR_INSTALL_STAGING = YES
AUDIOCAPTUREMGR_DEPENDENCIES = iarmbus iarmmgrs


AUDIOCAPTUREMGR_CONF_OPTS  = --enable-testapp

AUDIOCAPTUREMGR_CONF_OPTS = \
	--includedir=$(STAGING_DIR) \
	--libdir=$(STAGING_DIR)/usr \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR)


AUDIOCAPTUREMGR_EXTRA_FLAGS += \
 	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -std=c++11 -fexceptions  -I$(STAGING_DIR)/usr/include/media-utils/audioCapture    -I$(STAGING_DIR)/usr/include/rdk/iarmbus  -I$(STAGING_DIR)/usr/include/trower-base64" \
	-DCMAKE_C_FLAGS_RELEASE="$(TARGET_CFLAGS) $(RDKSERVICES_SYMBOL_FLAGS) $(RDKSERVICES_DEBUG_BUILD_FLAGS) -fexceptions -Wno-cast-align" \
	-DCMAKE_CXX_FLAGS_RELEASE="$(TARGET_CXXFLAGS) $(RDKSERVICES_SYMBOL_FLAGS) $(RDKSERVICES_DEBUG_BUILD_FLAGS) -fexceptions -Wno-cast-align" \
	-DCMAKE_C_FLAGS_DEBUG="$(TARGET_CFLAGS) $(RDKSERVICES_SYMBOL_FLAGS) $(RDKSERVICES_DEBUG_BUILD_FLAGS) -fexceptions -Wno-cast-align" \
	-DCMAKE_CXX_FLAGS_DEBUG="$(TARGET_CXXFLAGS)$(RDKSERVICES_SYMBOL_FLAGS) $(RDKSERVICES_DEBUG_BUILD_FLAGS) -fexceptions -Wno-cast-align"

 $(eval $(autotools-package))
