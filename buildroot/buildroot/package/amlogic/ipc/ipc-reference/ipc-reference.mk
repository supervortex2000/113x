#############################################################
#
# IPC REFAPP
#
#############################################################

IPC_REFERENCE_VERSION = 1.0
IPC_REFERENCE_SITE_METHOD = local
IPC_REFERENCE_INSTALL_STAGING = YES
IPC_REFERENCE_LOCAL_SRC = $(wildcard $(TOPDIR)/../vendor/amlogic/ipc/refapp/src)
IPC_REFERENCE_LOCAL_PREBUILT = $(TOPDIR)/../vendor/amlogic/ipc/refapp/prebuilt

IPC_REFERENCE_DEPENDENCIES = mbi sensor libglib2 jpeg-turbo opencv3 openssl fdk-aac quirc
IPC_REFERENCE_CFLAGS := $(TARGET_CFLAGS)

IPC_REFERENCE_MAKE_ENV = $(TARGET_MAKE_ENV) \
                         CFLAGS="$(IPC_REFERENCE_CFLAGS)" \
                         IPC_SDK_LIB_DIR=$(STAGING_DIR)/usr/lib/ \
                         IPC_SDK_INC_DIR=$(STAGING_DIR)/usr/include \
                         LINUX_KERNEL_DIR=$(LINUX_DIR)

ifneq ($(IPC_REFERENCE_LOCAL_SRC),)

IPC_REFERENCE_SITE = $(IPC_REFERENCE_LOCAL_SRC)
IPC_REFERENCE_GIT_VERSION=$(shell \
            if [ -d $(IPC_REFERENCE_SITE)/.git ]; then \
                git -C $(IPC_REFERENCE_SITE) describe --abbrev=8 --always --tags; \
            else \
              echo "unknown"; \
            fi)

define IPC_REFERENCE_BUILD_CMDS
	if [ -d "$(@D)/drivers" ]; then \
		cd $(@D)/drivers; \
		$(TARGET_CONFIGURE_OPTS) $(IPC_REFERENCE_MAKE_ENV) $(MAKE) -C $(LINUX_DIR) M=$(@D)/drivers \
		ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(TARGET_KERNEL_CROSS) modules; \
		cd -; \
	fi

	REVISION=$(IPC_REFERENCE_GIT_VERSION) $(TARGET_CONFIGURE_OPTS) $(IPC_REFERENCE_MAKE_ENV) $(MAKE) -C $(@D)
endef

ifeq ($(BR2_IPC_REFERENCE_DOORBELL),y)

define IPC_REFERENCE_INSTALL_TARGET_CMDS
	-cp -rf $(@D)/rootfs/* $(TARGET_DIR)/
endef

else

define IPC_REFERENCE_INSTALL_TARGET_CMDS
	-mkdir -p $(@D)/rootfs/usr/bin/
	-$(INSTALL) -D -m 755 $(@D)/refapp/ipc-refapp $(@D)/rootfs/usr/bin/

	-mkdir -p $(@D)/rootfs/web/var
	-cp -rf $(@D)/www $(@D)/rootfs/web/var/

	echo "IPC-REFAPP-REVISION=$(IPC_REFERENCE_GIT_VERSION)" > $(@D)/rootfs/etc/ipc-refapp-version.txt
   -tar -czf $(BINARIES_DIR)/ipc-refapp-prebuilt.tgz -C $(@D)/ rootfs
	-cp -rf $(@D)/rootfs/* $(TARGET_DIR)/
	-cp -rf $(@D)/rootfs/* $(IPC_REFERENCE_LOCAL_PREBUILT)/rootfs/
endef

endif

else #prebuilt
IPC_REFERENCE_SITE = $(IPC_REFERENCE_LOCAL_PREBUILT)

define IPC_REFERENCE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(IPC_REFERENCE_MAKE_ENV) $(MAKE) -C $(@D)
endef

define IPC_REFERENCE_INSTALL_TARGET_CMDS
    cp -rf $(@D)/rootfs/* $(TARGET_DIR)/
endef

endif

$(eval $(generic-package))
