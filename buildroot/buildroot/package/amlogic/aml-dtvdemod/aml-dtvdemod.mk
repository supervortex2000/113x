#############################################################
#
# DTV demod firmware
#
#############################################################

AML_DTVDEMOD_SITE = $(TOPDIR)/../vendor/amlogic/dtvdemod
AML_DTVDEMOD_SITE_METHOD = local

AML_DTVDEMOD_FIRMWARE_INSTALL_DIR = $(TARGET_DIR)/lib/firmware/dtvdemod

define AML_DTVDEMOD_BUILD_CMDS
	echo "DTV demod firmware compile"
endef

define AML_DTVDEMOD_INSTALL_TARGET_CMDS
	-mkdir -p $(AML_DTVDEMOD_FIRMWARE_INSTALL_DIR)
	$(INSTALL) -D -m 0644 $(@D)/firmware/dtvdemod_t2.bin $(AML_DTVDEMOD_FIRMWARE_INSTALL_DIR)
endef

$(eval $(generic-package))
