################################################################################
#
# playready prebuilt
#
################################################################################

PLAYREADY_BIN_VERSION = $(call qstrip,$(BR2_PACKAGE_PLAYREADY_BIN_VERSION))
PLAYREADY_BIN_SITE = $(TOPDIR)/../multimedia/libmediadrm/playready-bin/prebuilt-v$(PLAYREADY_BIN_VERSION)
PLAYREADY_BIN_SITE_METHOD = local
PLAYREADY_BIN_INSTALL_TARGET := YES
PLAYREADY_BIN_INSTALL_STAGING := YES
PLAYREADY_BIN_DEPENDENCIES = tdk

PR_BIN_PREBUILT_DIRECTORY = $(call qstrip,$(BR2_ARCH)).$(call qstrip,$(BR2_GCC_TARGET_ABI)).$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))

define PLAYREADY_BIN_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/$(PR_BIN_PREBUILT_DIRECTORY)/libplayready-$(PLAYREADY_BIN_VERSION).so \
		$(STAGING_DIR)/usr/lib/
#if there is headfile exist, install headfile and playready.pc
	if [ -d $(@D)/noarch/include ] ; then \
		mkdir -p $(STAGING_DIR)/usr/include/playready; \
		cp -r $(@D)/noarch/include/* $(STAGING_DIR)/usr/include/playready; \
	fi
	if [ -f $(@D)/noarch/pkgconfig/playready.pc ] ; then \
	$(INSTALL) -D -m 0644 $(@D)/noarch/pkgconfig/playready.pc $(STAGING_DIR)/usr/lib/pkgconfig; \
	fi
	ln -sf libplayready-$(PLAYREADY_BIN_VERSION).so \
		$(STAGING_DIR)/usr/lib/libplayready.so
endef

define PLAYREADY_BIN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/$(PR_BIN_PREBUILT_DIRECTORY)/libplayready-$(PLAYREADY_BIN_VERSION).so \
		$(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 0644 $(@D)/noarch/ta/$(TA_PATH)/*.ta $(TARGET_DIR)/lib/teetz
	$(INSTALL) -D -m 0755 $(@D)/$(PR_BIN_PREBUILT_DIRECTORY)/prtest $(TARGET_DIR)/usr/bin
	ln -sf libplayready-$(PLAYREADY_BIN_VERSION).so \
		$(TARGET_DIR)/usr/lib/libplayready.so
endef


$(eval $(generic-package))
