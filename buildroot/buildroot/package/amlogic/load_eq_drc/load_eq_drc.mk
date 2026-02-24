#
# eq_test
#
LOAD_EQ_DRC_VERSION = 1.0
LOAD_EQ_DRC_SITE = $(TOPDIR)/package/amlogic/load_eq_drc/src
LOAD_EQ_DRC_SITE_METHOD = local

define LOAD_EQ_DRC_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) all
endef

define LOAD_EQ_DRC_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/load_eq_drc $(TARGET_DIR)/usr/bin/load_eq_drc
    $(INSTALL) -D -m 755 $(@D)/config/S72load_eq_drc $(TARGET_DIR)/etc/init.d
    $(INSTALL) -D -m 755 $(@D)/config/eq_drc_params.ini $(TARGET_DIR)/etc/eq_drc_params.ini
    $(INSTALL) -D -m 755 $(@D)/config/Amlogic_DRC_Param_Generator $(TARGET_DIR)/usr/bin/Amlogic_DRC_Param_Generator
    $(INSTALL) -D -m 755 $(@D)/config/Amlogic_EQ_Param_Generator $(TARGET_DIR)/usr/bin/Amlogic_EQ_Param_Generator
    if [ -f $(@D)/config/EXT_AMP.ini ]; then \
        $(INSTALL) -D -m 755 $(@D)/config/EXT_AMP.ini $(TARGET_DIR)/etc/EXT_AMP.ini; \
    fi
endef

define LOAD_EQ_DRC_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
