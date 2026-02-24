#############################################################
#
# mDNSResponder
#
#############################################################
MDNSRESPONDER_VERSION = 878.200.35
MDNSRESPONDER_SOURCE = mDNSResponder-$(MDNSRESPONDER_VERSION).tar.gz
MDNSRESPONDER_SITE = https://opensource.apple.com/tarballs/mDNSResponder
MDNSRESPONDER_DIR = $(BUILD_DIR)/mdnsresponder-$(MDNSRESPONDER_VERSION)
MDNSRESPONDER_LICENSE = \
						Apache-2.0, BSD-3c (shared library), GPLv2 (mDnsEmbedded.h), \
						NICTA Public Software Licence
MDNSRESPONDER_LICENSE_FILES = LICENSE
MDNSRESPONDER_INSTALL_STAGING = YES

debug = 0
TARGET_PATH = prod

ifeq ($(debug),1)
	TARGET_PATH = debug
endif

define MDNSRESPONDER_BUILD_CMDS
	$(MAKE1) CC=$(TARGET_CC) CFLAGS_EXTRA="$(TARGET_CFLAGS)" os="linux" LD="$(TARGET_CC) -shared" LOCALBASE="/usr" -C $(MDNSRESPONDER_DIR)/mDNSPosix STRIP=$(TARGET_STRIP) DEBUG=$(debug)
endef

define MDNSRESPONDER_INSTALL_STAGING_CMDS
	$(INSTALL) -m 644 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/libdns_sd.so $(STAGING_DIR)/usr/lib/
	cd $(STAGING_DIR)/usr/lib/;ln -sf libdns_sd.so libdns_sd.so.1
	$(INSTALL) -m 644 -D $(MDNSRESPONDER_DIR)/mDNSShared/dns_sd.h $(STAGING_DIR)/usr/include/
endef

define MDNSRESPONDER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mDNSResponderPosix $(TARGET_DIR)/usr/sbin/
	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mdnsd $(TARGET_DIR)/usr/sbin/

	$(INSTALL) -m 644 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/libdns_sd.so $(TARGET_DIR)/usr/lib/
	cd $(TARGET_DIR)/usr/lib/;ln -sf libdns_sd.so libdns_sd.so.1

	$(INSTALL) -m 0755 -D $(MDNSRESPONDER_PKGDIR)/S80mdns $(TARGET_DIR)/etc/init.d/

	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mDNSNetMonitor $(TARGET_DIR)/usr/sbin/

	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/Clients/build/dns-sd $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mDNSProxyResponderPosix $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mDNSIdentify $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 755 -D $(MDNSRESPONDER_DIR)/mDNSPosix/build/$(TARGET_PATH)/mDNSClientPosix $(TARGET_DIR)/usr/bin/
endef

mdnsresponder-clean:
	rm -f $(MDNSRESPONDER_DIR)/.configured $(MDNSRESPONDER_DIR)/.built $(MDNSRESPONDER_DIR)/.staged
	-$(MAKE1) os=linux -C $(MDNSRESPONDER_DIR)/mDNSPosix clean
	rm -f $(TARGET_DIR)/usr/sbin/mDNSResponderPosix \
		$(TARGET_DIR)/usr/sbin/mDNSNetMonitor \
		$(TARGET_DIR)/usr/sbin/mdnsd \
		$(TARGET_DIR)/usr/bin/dns-sd \
		$(TARGET_DIR)/usr/bin/mDNSProxyResponderPosix \
		$(TARGET_DIR)/usr/bin/mDNSIdentify \
		$(TARGET_DIR)/usr/bin/mDNSClientPosix \
		$(TARGET_DIR)/etc/init.d/S80mdns

mdnsresponder-dirclean:
	rm -rf $(MDNSRESPONDER_DIR)

$(eval $(generic-package))
