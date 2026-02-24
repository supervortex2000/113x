################################################################################
#
# aml_pqserver
#
################################################################################
AML_PQSERVER_SITE = $(TOPDIR)/../vendor/amlogic/aml_pqserver
AML_PQSERVER_VERSION=1.0
AML_PQSERVER_SITE_METHOD=local
AML_PQSERVER_DEPENDENCIES += linux
AML_PQSERVER_DEPENDENCIES += libzlib sqlite

ifeq ($(BR2_PACKAGE_AML_PQSERVER_USE_LIBBINDER),y)
TV_IPC_TYPE=TV_BINDER
AML_PQSERVER_DEPENDENCIES += libbinder liblog
else
TV_IPC_TYPE=TV_DBUS
AML_PQSERVER_DEPENDENCIES += dbus
endif

define AML_PQSERVER_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) TV_IPC_TYPE=$(TV_IPC_TYPE) -C $(@D) all
endef

define AML_PQSERVER_CLEAN_CMDS
	$(MAKE) TV_IPC_TYPE=$(TV_IPC_TYPE) -C $(@D) clean
endef

define AML_PQSERVER_INSTALL_TARGET_CMDS
	$(MAKE) TV_IPC_TYPE=$(TV_IPC_TYPE) -C $(@D) install
endef

ifeq ($(BR2_ARM_KERNEL_32),y)
  KERNEL_BITS=32
else
  KERNEL_BITS=64
endif

define AML_PQSERVER_INSTALL_PQ_DRIVER
	if ls $(BR2_PACKAGE_AML_VENDOR_PARTITION_PATH)/etc/driver/pq/$(KERNEL_BITS)/*.ko 2>&1 > /dev/null; then \
		pushd $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/; \
		rm -fr pq && ln -s /vendor/etc/driver/pq/$(KERNEL_BITS) pq; \
		for ko in $$(find $(BR2_PACKAGE_AML_VENDOR_PARTITION_PATH)/etc/driver/pq/$(KERNEL_BITS)/ -name '*.ko' -printf "%f\n"); \
		do echo "pq/$$ko:" >> modules.dep; done;\
		popd; \
	fi
endef
#AML_PQSERVER_POST_INSTALL_TARGET_HOOKS += AML_PQSERVER_INSTALL_PQ_DRIVER

define AML_PQSERVER_INSTALL_PQSERVICE
	install -m 755 $(AML_PQSERVER_PKGDIR)/S55_aml_pqservice $(TARGET_DIR)/etc/init.d/
endef
AML_PQSERVER_POST_INSTALL_TARGET_HOOKS += AML_PQSERVER_INSTALL_PQSERVICE

define AML_PQSERVER_UNINSTALL_TARGET_CMDS
        $(MAKE) -C $(@D) uninstall
endef

$(eval $(generic-package))
