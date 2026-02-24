############################################################
#
# AML QT DEMO--launcher
#
#############################################################
AML_QT_LAUNCHER_DEPENDENCIES += qt5base qt5multimedia

#install qt launch demo without boot aniamtion
define AML_QT_LAUNCHER_INSTALL_TARGET_CMDS
    cp $(TOPDIR)/package/amlogic/aml-qt-demo/aml-qt-launcher/S12qtlauncher $(TARGET_DIR)/etc/init.d
if [ "$(BR2_PACKAGE_BOOT_ANIMATION)" == "y" ] ; then \
	cp $(TOPDIR)/package/amlogic/aml-qt-demo/aml-qt-launcher/S12qtlauncher_with_bootanimation $(TARGET_DIR)/etc/init.d/S12qtlauncher; \
fi
endef

$(eval $(generic-package))
