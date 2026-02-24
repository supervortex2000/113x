############################################################
#
# AML QT DEMO--camera
#
#############################################################

AML_QT_CAMERA_VERSION = 1.0
AML_QT_CAMERA_SITE = $(TOPDIR)/package/amlogic/aml-qt-demo/aml-qt-camera/src
AML_QT_CAMERA_SITE_METHOD = local
AML_QT_CAMERA_INSTALL_STAGING = NO

AML_QT_CAMERA_DEPENDENCIES += qt5base qt5multimedia

define AML_QT_CAMERA_CONFIGURE_CMDS
    (cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define AML_QT_CAMERA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define AML_QT_CAMERA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/qt-demo-camera $(TARGET_DIR)/usr/bin/
endef


$(eval $(generic-package))
