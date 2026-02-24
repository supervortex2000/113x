################################################################################
#
# libsqe_api
#
################################################################################

IPC_SQE_VERSION:=1.0
IPC_SQE_SITE := $(TOPDIR)/../vendor/amlogic/ipc/ipc-sqe
IPC_SQE_SITE_METHOD:=local
IPC_SQE_INSTALL_STAGING:=YES

IPC_SQE_DEPENDENCIES += webrtc-apm

define IPC_SQE_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D)
endef

define IPC_SQE_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libsqe_api.so $(TARGET_DIR)/usr/lib/
endef

define IPC_SQE_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libsqe_api.so \
        $(STAGING_DIR)/usr/lib/libsqe_api.so
    $(INSTALL) -m 0644 $(@D)/include/*.h \
        $(STAGING_DIR)/usr/include
endef

define IPC_SQE_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CC) -C $(@D) clean
endef

$(eval $(generic-package))
