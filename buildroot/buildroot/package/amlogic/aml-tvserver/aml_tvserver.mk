################################################################################
#
# aml_tvserver
#
################################################################################
AML_TVSERVER_SITE = $(TOPDIR)/../vendor/amlogic/aml_tvserver
AML_TVSERVER_VERSION=1.0
AML_TVSERVER_SITE_METHOD=local
AML_TVSERVER_INSTALL_STAGING=YES
AML_TVSERVER_DEPENDENCIES += linux libbinder liblog
AML_TVSERVER_DEPENDENCIES += libzlib hal-audio-service

define AML_TVSERVER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D) all
endef

define AML_TVSERVER_CLEAN_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

define AML_TVSERVER_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libtvclient.so $(STAGING_DIR)/usr/lib/
	mkdir -p $(STAGING_DIR)/usr/include/tvclient
	$(INSTALL) -m 0644 $(@D)/client/include/* $(STAGING_DIR)/usr/include/tvclient/
endef

define AML_TVSERVER_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install
endef

ifeq ($(BR2_ARM_KERNEL_32),y)
  KERNEL_BITS=32
else
  KERNEL_BITS=64
endif

define AML_TVSERVER_INSTALL_TUNER_DRIVER
	if ls $(BR2_PACKAGE_AML_VENDOR_PARTITION_PATH)/etc/driver/tuner/$(KERNEL_BITS)/*.ko 2>&1 > /dev/null; then \
		pushd $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/; \
		rm -fr tuner && ln -s /vendor/etc/driver/tuner/$(KERNEL_BITS) tuner; \
		for ko in $$(find $(BR2_PACKAGE_AML_VENDOR_PARTITION_PATH)/etc/driver/tuner/$(KERNEL_BITS)/ -name '*.ko' -printf "%f\n"); \
		do echo "tuner/$$ko:" >> modules.dep; done;\
		popd; \
	fi
endef
#AML_TVSERVER_POST_INSTALL_TARGET_HOOKS += AML_TVSERVER_INSTALL_TUNER_DRIVER

define AML_TVSERVER_INSTALL_TVSERVICE
	install -m 755 $(AML_TVSERVER_PKGDIR)/S55_aml_tvservice $(TARGET_DIR)/etc/init.d/
endef
AML_TVSERVER_POST_INSTALL_TARGET_HOOKS += AML_TVSERVER_INSTALL_TVSERVICE

$(eval $(generic-package))