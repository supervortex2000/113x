################################################################################
#
# amlogic ircut module kernel driver
#
################################################################################

IPC_IRCUT_MODULE_VERSION = 1.0
IPC_IRCUT_MODULE_SITE = $(TOPDIR)/../vendor/amlogic/ipc/ipc-ircut-module
IPC_IRCUT_MODULE_SITE_METHOD = local
IPC_IRCUT_MODULE_DEPENDENCIES = linux
IPC_IRCUT_MODULE_INSTALL_STAGING = YES

# modules
IPC_IRCUT_MODULE_MODULE_DIR = kernel/amlogic/ircut
IPC_IRCUT_MODULE_INSTALL_DIR = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/amlogic/ircut
IPC_IRCUT_MODULE_DEP = $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/modules.dep
IPC_IRCUT_MODULE_INSTALL_STAGING_DIR = $(STAGING_DIR)/usr/include/linux
IPC_IRCUT_MODULE_UIO_HEADERS = $(@D)/ircut.h

define copy-ircut-modules
        $(foreach m, $(shell find $(strip $(1)) -name "*.ko"),\
                $(shell [ ! -e $(2) ] && mkdir $(2) -p;\
                cp $(m) $(strip $(2))/ -rfa;\
                echo $(4)/$(notdir $(m)): >> $(3)))
endef

define IPC_IRCUT_MODULE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(LINUX_DIR) \
		M=$(@D) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(TARGET_KERNEL_CROSS) \
		CONFIG_AMLOGIC_IRCUT=m modules
endef

define IPC_IRCUT_MODULE_CLEAN_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) clean
endef

define IPC_IRCUT_MODULE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(IPC_IRCUT_MODULE_UIO_HEADERS) $(IPC_IRCUT_MODULE_INSTALL_STAGING_DIR);
endef

define IPC_IRCUT_MODULE_INSTALL_TARGET_CMDS
	$(call copy-ircut-modules,$(@D),\
		$(shell echo $(IPC_IRCUT_MODULE_INSTALL_DIR)),\
		$(shell echo $(IPC_IRCUT_MODULE_DEP)),\
		$(IPC_IRCUT_MODULE_MODULE_DIR))
endef

$(eval $(generic-package))

