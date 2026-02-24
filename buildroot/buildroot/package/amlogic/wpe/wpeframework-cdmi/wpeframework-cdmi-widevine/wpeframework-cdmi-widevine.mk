################################################################################
#
# wpeframework-cdmi-widevine
#
################################################################################

WPEFRAMEWORK_CDMI_WIDEVINE_VERSION = 052b138536bf209981a9360cc9ce1ae990a792ed
WPEFRAMEWORK_CDMI_WIDEVINE_SITE_METHOD = git
WPEFRAMEWORK_CDMI_WIDEVINE_SITE = https://git@github.com/rdkcentral/OCDM-Widevine.git
WPEFRAMEWORK_CDMI_WIDEVINE_INSTALL_STAGING = NO
WPEFRAMEWORK_CDMI_WIDEVINE_DEPENDENCIES = wpeframework widevine-bin

$(eval $(cmake-package))
