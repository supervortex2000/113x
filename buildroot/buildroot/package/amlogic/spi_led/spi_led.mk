#
# spi_led
#
SPI_LED_VERSION = 1.0
SPI_LED_SITE = $(SPI_LED_PKGDIR)/src
SPI_LED_SITE_METHOD = local

define SPILED_ADD_LINUX_IOCTL
	$(SED) 's~^#include <sys/ioctl.h>~#include <sys/ioctl.h>\n#include <linux/ioctl.h>~' \
		$(@D)/spi_led.c
endef

SPIDEV_TEST_POST_PATCH_HOOKS += SPILED_ADD_LINUX_IOCTL

define SPI_LED_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CC) $(TARGET_CFLAGS) \
		-o $(@D)/spi_led $(@D)/spi_led.c
endef

define SPI_LED_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/spi_led \
		$(TARGET_DIR)/usr/sbin/spi_led
endef

define SPI_LED_INSTALL_CLEAN_CMDS
    $(MAKE) CC=$(TARGET_CXX) -C $(@D) clean
endef

$(eval $(generic-package))
