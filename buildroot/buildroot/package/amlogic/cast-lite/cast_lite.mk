#
# cast lite
#
CAST_LITE_VERSION = 1.0
CAST_LITE_SITE_METHOD = local
CAST_LITE_DEPENDENCIES = ffmpeg-aml
CAST_LITE_DEPENDENCIES += alsa-lib
CAST_LITE_DEPENDENCIES += libnss
CAST_LITE_DEPENDENCIES += libnspr

CAST_LITE_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/cast-lite/cast-sdk)
CAST_LITE_LOCAL_PREBUILT = $(wildcard $(TOPDIR)/../vendor/amlogic/cast-lite/cast-sdk_prebuild)
CAST_LITE_PREBUILT_DIRECTORY = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
CAST_LITE_SITE = $(CAST_LITE_PKGDIR)/fake

CAST_LITE_CONF_OPTS = \
	-B build \
	-DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_INSTALL_PREFIX=$(CAST_LITE_LOCAL_PREBUILT)

build_tool=$(generic-package)

ifneq ($(CAST_LITE_LOCAL_SRC),)
CAST_LITE_SITE=$(CAST_LITE_LOCAL_SRC)

define CAST_LITE_BUILD_CMDS
	$(MAKE) -C $(@D)/build all
endef

ifneq ($(CAST_LITE_LOCAL_PREBUILT),)
build_tool=$(cmake-package)
define CAST_LITE_UPDATE_PREBUILT_CMDS

	# DO NOT remove the first empty line
	$(INSTALL) -d  $(TARGET_DIR)/etc/cast_lite
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/assets $(TARGET_DIR)/etc/cast_lite/ -rf
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/certs  $(TARGET_DIR)/etc/cast_lite/ -rf
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/conf   $(TARGET_DIR)/etc/cast_lite/ -rf
	$(INSTALL) -m 755 -D $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/bin/* $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 -D $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/lib/* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 -D $(CAST_LITE_PKGDIR)/S84cast_lite $(TARGET_DIR)/etc/init.d/
	cp $(CAST_LITE_LOCAL_PREBUILT)/include/* $(STAGING_DIR)/usr/include/ -rf
endef
	CAST_LITE_INSTALL_TARGET_CMDS += $(MAKE) -C $(@D)/build install
	CAST_LITE_INSTALL_TARGET_CMDS += $(CAST_LITE_UPDATE_PREBUILT_CMDS)
endif

else # prebuilt

ifneq ($(CAST_LITE_LOCAL_PREBUILT),)

define CAST_LITE_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)/client_sample all
endef

build_tool=$(generic-package)
CAST_LITE_SITE=$(CAST_LITE_LOCAL_PREBUILT)
define CAST_LITE_INSTALL_TARGET_CMDS
	$(INSTALL) -d  $(TARGET_DIR)/etc/cast_lite
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/assets $(TARGET_DIR)/etc/cast_lite/ -rf
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/certs  $(TARGET_DIR)/etc/cast_lite/ -rf
	cp $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/conf   $(TARGET_DIR)/etc/cast_lite/ -rf
	$(INSTALL) -m 755 -D $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/bin/* $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 -D $(CAST_LITE_LOCAL_PREBUILT)/target_runtime_armv7a/lib/* $(TARGET_DIR)/usr/lib/
	$(INSTALL) -m 755 -D $(CAST_LITE_PKGDIR)/S84cast_lite $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 755 -D $(@D)/client_sample/cast_control_app $(TARGET_DIR)/usr/bin
	cp $(CAST_LITE_LOCAL_PREBUILT)/include/* $(STAGING_DIR)/usr/include/ -rf

endef

endif

endif

define CAST_LITE_INSTALL_CLEAN_CMDS
	rm  $(TARGET_DIR)/etc/cast_lite -rf
	rm  $(TARGET_DIR)/usr/lib/libcast_*
	rm  $(TARGET_DIR)/usr/bin/cast_control_cli
	rm  $(TARGET_DIR)/usr/bin/cast_sample_app
	rm  $(TARGET_DIR)/usr/bin/client_auth_indiv
	rm  $(TARGET_DIR)/usr/bin/crash_uploader
	rm  $(TARGET_DIR)/usr/bin/example_media_player
	rm  $(TARGET_DIR)/usr/bin/multizone
	rm  $(TARGET_DIR)/usr/bin/cast_control_app
endef

$(eval $(build_tool))
