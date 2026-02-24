################################################################################
#
# aml-uac
#
################################################################################
SRC_KERNEL_PATCHES=package/amlogic/aml-uac/kernel-patch
DST_KERNEL_PATCHES=linux/amlogic-4.19-dev

SRC_BLUEZ-ALSA_PATCHES=package/amlogic/aml-uac/bluez-alsa-patch
DST_BLUEZ-ALSA_PATCHES=package/amlogic/bluez-alsa


ifeq ($(BR2_PACKAGE_AML_UAC), y)
files = $(shell ls $(SRC_KERNEL_PATCHES)/uac*.patch 2>/dev/null | wc -l)
ifneq ($(files), 0)
$(info "apply uac's kernel patches!")
$(shell cp -rf $(SRC_KERNEL_PATCHES)/uac*.patch $(DST_KERNEL_PATCHES)/)
endif

files = $(shell ls $(SRC_BLUEZ-ALSA_PATCHES)/uac*.patch 2>/dev/null | wc -l)
ifneq ($(files), 0)
$(info "apply uac's bluez-alsa patches!")
$(shell cp -rf $(SRC_BLUEZ-ALSA_PATCHES)/uac*.patch $(DST_BLUEZ-ALSA_PATCHES)/)
endif

else

files = $(shell ls $(DST_KERNEL_PATCHES)/uac*.patch 2>/dev/null | wc -l)
ifneq ($(files), 0)
$(info "remove uac's kernel patches!")
$(shell rm $(DST_KERNEL_PATCHES)/uac*.patch)
endif

files = $(shell ls $(DST_BLUEZ-ALSA_PATCHES)/uac*.patch 2>/dev/null | wc -l)
ifneq ($(files), 0)
$(info "remove uac's bluez-alsa patches!")
$(shell rm $(DST_BLUEZ-ALSA_PATCHES)/uac*.patch)
endif


endif

