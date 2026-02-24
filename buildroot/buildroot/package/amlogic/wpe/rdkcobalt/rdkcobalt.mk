RDKCOBALT_VERSION = $(call qstrip,$(BR2_PACKAGE_RDKCOBALT_VERSION))
RDKCOBALT_MAJOR_VERSION = $(shell echo $(RDKCOBALT_VERSION) | cut -d'.' -f1)



RDKCOBALT_INSTALL_STAGING = YES
#RDKCOBALT_DEPENDENCIES = opencdm

RDKCOBALT_DEPOT_TOOLS_PATH = $(BROWSER_DEPOT_TOOL_PATH)
RDKCOBALT_STARBOARD_PATH = $(TOPDIR)/../vendor/amlogic/cobalt


ifeq ($(BR2_aarch64), y)
RDKCOBALT_TOOLCHAIN_DEPENDENCIES = browser_toolchain_gcc-linaro-aarch64
RDKCOBALT_TOOLCHAIN_DIR = $(BROWSER_TOOLCHAIN_GCC_LINARO_AARCH64_INSTALL_DIR)/bin
RDKCOBALT_ARCH=arm64
RDKCOBALT_CROSS=aarch64-linux-gnu-
else
RDKCOBALT_TOOLCHAIN_DEPENDENCIES = browser_toolchain_gcc-linaro-armeabihf
RDKCOBALT_TOOLCHAIN_DIR = $(BROWSER_TOOLCHAIN_GCC_LINARO_ARMEABIHF_INSTALL_DIR)/bin
RDKCOBALT_ARCH=arm
RDKCOBALT_CROSS=arm-linux-gnueabihf-
endif

RDK_STARBOARD_DEPENDENCIES = gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad youtubesign-bin
RDKCOBALT_DEPENDENCIES = host-pkgconf $(RDK_STARBOARD_DEPENDENCIES) wpeframework browser_toolchain_depot_tools \
                        $(RDKCOBALT_TOOLCHAIN_DEPENDENCIES)
RDKCOBALT_SOURCE = cobalt-$(RDKCOBALT_VERSION).tar.gz
RDKCOBALT_SITE = file://$(TOPDIR)/../vendor/amlogic/external/packages
RDKCOBALT_STRIP_COMPONENTS=0

RDKCOBALT_OUT_DIR = $(RDKCOBALT_DIR)/src/out/rdk-arm_qa

ifeq ($(BR2_PACKAGE_RDKCOBALT_NPLB), y)
RDKCOBALT_OUT_DIR = $(RDKCOBALT_DIR)/src/out/rdk-arm_debug
NPLB_BIN = nplb
endif

RDKCOBALT_LOCAL_HTML = $(TOPDIR)/package/amlogic/cobalt


define RDKCOBALT_BUILD_CMDS
# sync starboard code
	if [ -d $(RDKCOBALT_STARBOARD_PATH)/rdkcobalt-$(RDKCOBALT_MAJOR_VERSION) ] ; then \
		rsync -a $(RDKCOBALT_STARBOARD_PATH)/rdkcobalt-$(RDKCOBALT_MAJOR_VERSION)/src/third_party/starboard $(RDKCOBALT_DIR)/src/third_party ; \
	else \
		echo "there is no RDK startbaord exist, exit"; \
		exit 1 ; \
	fi
# for nplb build
#	if [ -n "$(NPLB_BIN)" ] ; then \
#		sed -i 's/#define.*SB_HAS_IPV6.*/#define SB_HAS_IPV6 0/' \
#		$(RDKCOBALT_DIR)/src/third_party/starboard/rdk/arm/configuration_public.h; \
#	fi
# configure and build
	export CC="$(RDKCOBALT_CROSS)gcc -mfloat-abi=hard -fno-omit-frame-pointer -fno-optimize-sibling-calls --sysroot=$(STAGING_DIR)"; \
	export CCACHE_DISABLE="1"; \
	export CFLAGS=" -Os -pipe -g -feliminate-unused-debug-types"; \
  export CPP="$(RDKCOBALT_CROSS)gcc -E --sysroot=$(STAGING_DIR) -march=armv7-a -mthumb -mfpu=neon  -mfloat-abi=hard -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wno-expansion-to-defined "; \
	export CPPFLAGS=""; \
	export FC="$(RDKCOBALT_CROSS)gfortran -march=armv7-a -mthumb -mfpu=neon  -mfloat-abi=hard -fno-omit-frame-pointer -fno-optimize-sibling-calls "; \
	export LDFLAGS="-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed  "; \
	export CXX="$(RDKCOBALT_CROSS)g++ -mfloat-abi=hard -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wno-expansion-to-defined -Wno-implicit-fallthrough --sysroot=$(STAGING_DIR) "; \
	export CXXFLAGS=" -Os -pipe -g -feliminate-unused-debug-types -fvisibility-inlines-hidden -fpermissive -Werror=sign-compare -Wno-expansion-to-defined"; \
	export SYS_ROOT=$(STAGING_DIR); \
	export COBALT_CFLAGS="$(TOOLCHAIN_EXTERNAL_CFLAGS)"; \
	export COBALT_ARCH=$(RDKCOBALT_ARCH); \
	export COBALT_CROSS=$(RDKCOBALT_CROSS); \
	export PATH=$(RDKCOBALT_TOOLCHAIN_DIR):$(RDKCOBALT_DEPOT_TOOLS_PATH):$(PATH); \
	export PKG_CONFIG_DIR=$(STAGING_DIR)/usr/lib/pkgconfig; \
	export PKG_CONFIG_DISABLE_UNINSTALLED="yes"; \
	export PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig; \
	export PKG_CONFIG_PATH=$(STAGING_DIR)/usr/lib/pkgconfig; \
	export PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR); \
	export PKG_CONFIG_SYSTEM_INCLUDE_PATH="/usr/include"; \
	export PKG_CONFIG_SYSTEM_LIBRARY_PATH="/lib:/usr/lib"; \
	export PSEUDO_DISABLED="1"; \
	export PSEUDO_UNLOAD="1"; \
  export PYTHON="$(HOST_DIR)/bin/python"; \
  export RANLIB="$(RDKCOBALT_CROSS)ranlib"; \
  export READELF="$(RDKCOBALT_CROSS)readelf"; \
	export STAGING_INCDIR="$(SYS_ROOT)/usr/include"; \
	export STAGING_LIBDIR="$(SYS_ROOT)/usr/lib"; \
	export COBALT_HAS_OCDM=1; \
	export COBALT_VIDEO_RESOLUTION=$(BR2_PACKAGE_RDKCOBALT_VIDEO_RESOLUTION); \
	export COBALT_EXECUTABLE_TYPE=shared_library; \
	cd $(RDKCOBALT_DIR)/src; \
	cobalt/build/gyp_cobalt rdk-arm; \
	export NINJA_STATUS='%p '; \
  ninja -C $(RDKCOBALT_OUT_DIR) cobalt cobalt_bin $(NPLB_BIN)

endef




define RDKCOBALT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/share
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -a $(RDKCOBALT_OUT_DIR)/cobalt_bin        $(TARGET_DIR)/usr/bin
	if [ -n "$(NPLB_BIN)" ] ; then\
		cp -a $(RDKCOBALT_OUT_DIR)/nplb        $(TARGET_DIR)/usr/bin; \
	fi
	cp -arf $(RDKCOBALT_OUT_DIR)/content          	$(TARGET_DIR)/usr/share
	cp -a $(RDKCOBALT_OUT_DIR)/lib/libcobalt.so          	$(TARGET_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/lib
	cp -a $(RDKCOBALT_OUT_DIR)/lib/libcobalt.so $(STAGING_DIR)/usr/lib
	mkdir -p $(STAGING_DIR)/usr/include/starboard/rdk/arm
	cp -a $(RDKCOBALT_DIR)/src/third_party/starboard/rdk/arm/configuration_public.h $(STAGING_DIR)/usr/include/starboard/rdk/arm
	cp -a $(RDKCOBALT_DIR)/src/starboard/export.h $(STAGING_DIR)/usr/include/starboard
	cp -a $(RDKCOBALT_DIR)/src/starboard/configuration.h $(STAGING_DIR)/usr/include/starboard
	if [ -d $(RDKCOBALT_LOCAL_HTML)/launcher ] ; then \
		mkdir -p $(TARGET_DIR)/var/www; \
		cp -af $(RDKCOBALT_LOCAL_HTML)/launcher $(TARGET_DIR)/var/www; \
	fi
endef

$(eval $(generic-package))
