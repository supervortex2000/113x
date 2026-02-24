#####################################################################################
#
#apl client library sdk
#
####################################################################################
APL_CLIENT_LIBRARY_SITE = $(TOPDIR)/../vendor/amlogic/apl-client-library
APL_CLIENT_LIBRARY_SITE_METHOD=local
APL_CLIENT_LIBRARY_LICENSE=Apache License 2.0
APL_CLIENT_LIBRARY_LICENSE=LICENSE
APL_CLIENT_LIBRARY_INSTALL_STAGING=NO

APL_CLIENT_LIBRARY_DEPENDENCIES = apl-core-library

APL_CLIENT_LIBRARY_CONF_OPTS = \
	-DAPLCORE_INCLUDE_DIR=${STAGING_DIR}/usr/include \
	-DYOGA_INCLUDE_DIR=${@D}/../apl-core-library/yoga-prefix/src/yoga \
	-DAPLCORE_LIB_DIR=${STAGING_DIR}/usr/lib \
	-DAPLCORE_BUILD_INCLUDE_DIR=${STAGING_DIR}/usr/include \
	-DYOGA_LIB_DIR=${STAGING_DIR}/usr/lib \
	-DAPL_CORE=ON  \
	-DAPLCORE_RAPIDJSON_INCLUDE_DIR=${STAGING_DIR}/usr/include/rapidjson \
	-DAPLCORE_BUILD=${@D}/../apl-core-library/ \
	-DBUILD_TESTING=OFF \
	-DSTANDALONE=ON \
	-DCMAKE_INSTALL_PREFIX=${@D}/../../target/usr


define APL_CLIENT_LIBRARY_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) $(NEON_SUPPORT) -C $(@D) install
endef

define APL_CLIENT_LIBRARY_INSTALL_TARGET_CMDS
$(info "apl-client-library: No need to install again, buildroot needs this cmd")
endef

$(eval $(cmake-package))
