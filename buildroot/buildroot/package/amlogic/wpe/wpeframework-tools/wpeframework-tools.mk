################################################################################
#
# wpeframework-tools
#
################################################################################

WPEFRAMEWORK_TOOLS_VERSION = f53eec83fe4d09daff30f2bdbfa908e2d8dfa4f6

HOST_WPEFRAMEWORK_TOOLS_SITE = $(call github,rdkcentral,Thunder,$(WPEFRAMEWORK_TOOLS_VERSION))
HOST_WPEFRAMEWORK_TOOLS_INSTALL_STAGING = YES
HOST_WPEFRAMEWORK_TOOLS_INSTALL_TARGET = NO
HOST_WPEFRAMEWORK_TOOLS_DEPENDENCIES = host-cmake host-python3 host-python3-jsonref
HOST_WPEFRAMEWORK_TOOLS_SUBDIR = Tools

$(eval $(host-cmake-package))
