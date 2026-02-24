################################################################################
#
# wpeframework-rdkshell
#
################################################################################

RDKSHELL_VERSION = cc85216e3d2a968c8d91b65038f541541c6130f9
RDKSHELL_SITE_METHOD = git
RDKSHELL_SITE = git://github.com/rdkcentral/RDKShell
RDKSHELL_INSTALL_STAGING = YES
RDKSHELL_DEPENDENCIES = westeros


define RDKSHELL_INSTALL_TARGET_CMDS


	install -d  $(TARGET_DIR)/usr/bin
   install -d  $(TARGET_DIR)/usr/lib

   install -m 0755 $(@D)/rdkshell $(TARGET_DIR)/usr/bin  
   install -m 0755 $(@D)/librdkshell.so  $(TARGET_DIR)/usr/lib

   mkdir -p  $(TARGET_DIR)/usr/lib/plugins/westeros
   cp -a $(@D)/extensions/RdkShellExtendedInput/libwesteros_plugin_rdkshell_extended_input.so $(TARGET_DIR)/usr/lib/plugins/westeros/libwesteros_plugin_rdkshell_extended_input.so

   install -d  $(STAGING_DIR)/usr/lib
   install -d $(STAGING_DIR)/usr/include/rdkshell
   mkdir -p $(STAGING_DIR)/usr/include/rdkshell

   install -m 0644 $(@D)/*.h $(STAGING_DIR)/usr/include/rdkshell
   install -m 0755 $(@D)/librdkshell.so  $(STAGING_DIR)/usr/lib
endef


$(eval $(cmake-package))
