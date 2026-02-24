#####################################################################################
#
#apl core library sdk
#
####################################################################################
#APL_CORE_LIBRARY_VERSION:=1.9.0
APL_CORE_LIBRARY_SITE = $(TOPDIR)/../vendor/amlogic/apl-core-library
APL_CORE_LIBRARY_SITE_METHOD=local
APL_CORE_LIBRARY_LICENSE=Apache License 2.0
APL_CORE_LIBRARY_LICENSE=LICENSE
APL_CORE_LIBRARY_INSTALL_STAGING=NO

APL_CORE_LIBRARY_CONF_OPTS = \
                            -DBUILD_OUT_OF_TREE=ON \
                            -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                            -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
                            -DCMAKE_INSTALL_PREFIX=${STAGING_DIR}/usr

export APL_CORE_LIBRARY_BUILD_DIR = $(BUILD_DIR)
export APL_CORE_LIBRARY_STAGING_DIR = $(STAGING_DIR)
export APL_CORE_LIBRARY_TARGET_DIR = $(TARGET_DIR)
export APL_CORE_LIBRARY_BR2_ARCH = $(BR2_ARCH)


define APL_CORE_LIBRARY_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) CC=$(TARGET_CC) -C $(@D) install
endef

define APL_CORE_LIBRARY_INSTALL_TARGET_CMDS
$(info "apl-core-library: No need to install again, buildroot needs this cmd")
endef


$(eval $(cmake-package))
