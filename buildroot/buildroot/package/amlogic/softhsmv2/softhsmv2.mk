#####################################################################################
#
#softhsmv2
#
####################################################################################

SOFTHSMV2_SITE = $(BR2_PACKAGE_SOFTHSMV2_SITE)
SOFTHSMV2_SITE_METHOD = local
SOFTHSMV2_LICENSE = Apache License 2.0
SOFTHSMV2_LICENSE = LICENSE
SOFTHSMV2_INSTALL_STAGING = YES
SOFTHSMV2_DEPENDENCIES = openssl

SOFTHSMV2_CONF_OPTS = -DCMAKE_BUILD_TYPE=RELEASE \
		   	-DENABLE_ECC=OFF \
			-DENABLE_EDDSA=OFF \
			-DENABLE_STATIC=OFF


define SOFTHSMV2_POST_INSTALL_TARGET 
	mkdir -p $(TARGET_DIR)/var/lib/softhsm/tokens
	cp -r $(SOFTHSMV2_PKGDIR)/51c66e02-a01c-5733-a06b-39781cd3e833 $(TARGET_DIR)/var/lib/softhsm/tokens/
endef

SOFTHSMV2_POST_INSTALL_TARGET_HOOKS += SOFTHSMV2_POST_INSTALL_TARGET

$(eval $(cmake-package))
