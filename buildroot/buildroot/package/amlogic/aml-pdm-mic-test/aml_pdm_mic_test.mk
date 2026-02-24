#
# aml_pdm_mic_test
#
AML_PDM_MIC_TEST_VERSION = 1.0
AML_PDM_MIC_TEST_SITE = $(AML_PDM_MIC_TEST_PKGDIR)/src
AML_PDM_MIC_TEST_SITE_METHOD = local

define AML_PDM_MIC_TEST_BUILD_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) all
endef

define AML_PDM_MIC_TEST_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/Aml_Mic_Test $(TARGET_DIR)/usr/bin/Aml_Mic_Test
    $(INSTALL) -D -m 0755 $(AML_PDM_MIC_TEST_PKGDIR)/pdm_mic_test.sh $(TARGET_DIR)/usr/bin/pdm_mic_test.sh
    $(INSTALL) -D -m 0755 $(AML_PDM_MIC_TEST_PKGDIR)/media/2ch_1khz-16b-10s.wav $(TARGET_DIR)/usr/share/sounds/
endef

define AML_PDM_MIC_TEST_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
