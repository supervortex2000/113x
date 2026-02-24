################################################################################
#
# systemd
#
################################################################################

AML_SYSTEMD_VERSION = 244.3
AML_SYSTEMD_SOURCE =systemd-$(AML_SYSTEMD_VERSION).tar.gz
AML_SYSTEMD_SITE = $(call github,systemd,systemd-stable,v$(AML_SYSTEMD_VERSION))
AML_SYSTEMD_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README), BSD-3-Clause (tools/chromiumos)
AML_SYSTEMD_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README tools/chromiumos/LICENSE
AML_SYSTEMD_INSTALL_STAGING = YES
AML_SYSTEMD_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	$(if $(BR2_PACKAGE_BASH_COMPLETION),bash-completion) \
	host-gperf \
	kmod \
	libcap \
	util-linux \
	$(TARGET_NLS_DEPENDENCIES)



AML_SYSTEMD_CONF_OPTS += \
	-Drootlibdir='/usr/lib' \
	-Dblkid=true \
	-Dman=false \
	-Dima=false \
	-Dldconfig=false \
	-Ddefault-dnssec=no \
	-Ddefault-hierarchy=hybrid \
	-Dtests=false \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	-Dsystem-uid-max=999 \
	-Dsystem-gid-max=999 \
	-Dtelinit-path=$(TARGET_DIR)/sbin/telinit \
	-Dkmod-path=/usr/bin/kmod \
	-Dkexec-path=/usr/sbin/kexec \
	-Dsulogin-path=/usr/sbin/sulogin \
	-Dmount-path=/usr/bin/mount \
	-Dumount-path=/usr/bin/umount \
	-Dnobody-group=nogroup \
	-Didn=true \
	-Dnss-systemd=true


AML_SYSTEMD_TARGET_FINALIZE_HOOKS += AML_SYSTEMD_PRESET_ALL

AML_SYSTEMD_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
AML_SYSTEMD_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

# We need a very minimal host variant, so we disable as much as possible.
HOST_AML_SYSTEMD_CONF_OPTS = \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	--prefix=/usr \
	--libdir=lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	-Dutmp=false \
	-Dhibernate=false \
	-Dldconfig=false \
	-Dresolve=false \
	-Defi=false \
	-Dtpm=false \
	-Denvironment-d=false \
	-Dbinfmt=false \
	-Dcoredump=false \
	-Dpstore=false \
	-Dlogind=false \
	-Dhostnamed=false \
	-Dlocaled=false \
	-Dmachined=false \
	-Dportabled=false \
	-Dnetworkd=false \
	-Dtimedated=false \
	-Dtimesyncd=false \
	-Dremote=false \
	-Dcreate-log-dirs=false \
	-Dnss-myhostname=false \
	-Dnss-mymachines=false \
	-Dnss-resolve=false \
	-Dnss-systemd=false \
	-Dfirstboot=false \
	-Drandomseed=false \
	-Dbacklight=false \
	-Dvconsole=false \
	-Dquotacheck=false \
	-Dsysusers=false \
	-Dtmpfiles=false \
	-Dimportd=false \
	-Dhwdb=false \
	-Drfkill=false \
	-Dman=false \
	-Dhtml=false \
	-Dsmack=false \
	-Dpolkit=false \
	-Dblkid=false \
	-Didn=false \
	-Dadm-group=false \
	-Dwheel-group=false \
	-Dzlib=false \
	-Dgshadow=false \
	-Dima=false \
	-Dtests=false \
	-Dglib=false \
	-Dacl=false \
	-Dsysvinit-path=''

HOST_AML_SYSTEMD_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	host-util-linux \
	host-patchelf \
	host-libcap \
	host-gperf

# Fix RPATH After installation
# * systemd provides a install_rpath instruction to meson because the binaries
#   need to link with libsystemd which is not in a standard path
# * meson can only replace the RPATH, not append to it
# * the original rpath is thus lost.
# * the original path had been tweaked by buildroot via LDFLAGS to add
#   $(HOST_DIR)/lib
# * thus re-tweak rpath after the installation for all binaries that need it
HOST_AML_SYSTEMD_HOST_TOOLS = \
	systemd-analyze \
	systemd-machine-id-setup \
	systemd-mount \
	systemd-nspawn \
	systemctl \
	udevadm

HOST_AML_SYSTEMD_NINJA_ENV = DESTDIR=$(HOST_DIR)


HOST_AML_SYSTEMD_POST_INSTALL_HOOKS += HOST_AML_SYSTEMD_FIX_RPATH

$(eval $(meson-package))
$(eval $(host-meson-package))
