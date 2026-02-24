################################################################################
#
# desensitized ffmpeg
#
################################################################################

FFMPEG_AML_VERSION = 1.0.0
#FFMPEG_AML_SOURCE = ffmpeg-4.4.tar.xz
#FFMPEG_AML_SITE = http://ffmpeg.org/releases
FFMPEG_AML_SITE = $(TOPDIR)/../vendor/amlogic/ffmpeg-aml
FFMPEG_AML_SITE_METHOD = local
FFMPEG_AML_INSTALL_STAGING = YES

FFMPEG_AML_LICENSE = LGPL-2.1+, libjpeg license
FFMPEG_AML_LICENSE_FILES = LICENSE.md COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG_AML_GPL),y)
FFMPEG_AML_LICENSE += and GPL-2.0+
FFMPEG_AML_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG_AML_CONF_OPTS = \
	--prefix=/usr \
	--enable-avfilter \
	--disable-version3 \
	--enable-logging \
	--enable-optimizations \
	--disable-extra-warnings \
	--enable-ffmpeg \
	--enable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-network \
	--disable-gray \
	--enable-swscale-alpha \
	--disable-small \
	--enable-dct \
	--enable-fft \
	--enable-mdct \
	--enable-rdft \
	--disable-crystalhd \
	--disable-dxva2 \
	--enable-runtime-cpudetect \
	--disable-hardcoded-tables \
	--disable-mipsdsp \
	--disable-mipsdspr2 \
	--disable-msa \
	--enable-hwaccels \
	--disable-cuda \
	--disable-cuvid \
	--disable-nvenc \
	--disable-avisynth \
	--disable-frei0r \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libdc1394 \
	--disable-libgsm \
	--disable-libilbc \
	--disable-libvo-amrwbenc \
	--disable-symver \
	--disable-protocol=libsmbclient \
	--disable-bsf=dca_core,eac3_core,truehd_core \
	--disable-encoder=libvorbis,utvideo,flac,ac3,ac3_fixed,eac3,mlp,dca,spdif,truehd,flashsv,flashsv2,apng,exr,png,zmbv,zlib \
	--disable-decoder=libvorbis,cavs,dolby_e,ac3_fixed,ac3,eac3,mlp,dca,spdif,amrnb,h264_mediacodec,mvha,dxa,lscr,flashsv,tdsc,rasc,mscc,g2m,png,apng,mwsc,screenpresso,flashsv2,srgc,tscc,zmbv,rscc,zerocodec,wcmv,exr,mpl2,truemotion1 \
	--disable-demuxer=cavs,cavs2video,ac3,eac3,dts,dtshd,spdif,truehd,mpl2,av3a \
	--disable-muxer=cavs,cavs2video,ac3,eac3,dts,dtshd,spdif,av3a \
	--disable-parser=dca,mlp,av3a \
	--disable-doc

#libplayer should compile first, so libplayer will link to its own inside ffmpeg
FFMPEG_AML_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBPLAYER),libplayer)
FFMPEG_AML_DEPENDENCIES += host-pkgconf

#ffmpeg should compile first, so ffmpeg-aml must depend on ffmpeg
FFMPEG_AML_DEPENDENCIES += ffmpeg

# Apply the related patch for our hifi dsp in ffmpeg
ifeq ($(BR2_PACKAGE_AML_DSP_UTIL),y)
ifeq ($(BR2_PACKAGE_FFMPEG_AML_HIFI4DSP),y)
FFMPEG_AML_DEPENDENCIES += aml-dsp-util
define FFMPEG_AML_APPLY_HIFI4DSP_PATCHES
	if [ -d $(FFMPEG_AML_PKGDIR)/hifi4dsp  ]; then \
		$(APPLY_PATCHES) $(@D) $(FFMPEG_AML_PKGDIR)/hifi4dsp *.patch; \
	fi
endef
endif

FFMPEG_AML_POST_PATCH_HOOKS += FFMPEG_AML_APPLY_HIFI4DSP_PATCHES
endif

ifeq ($(BR2_PACKAGE_LIBXML2), y)
FFMPEG_AML_CONF_OPTS += --enable-libxml2
FFMPEG_AML_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_GPL),y)
FFMPEG_AML_CONF_OPTS += --enable-gpl
else
FFMPEG_AML_CONF_OPTS += --disable-gpl
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_NONFREE),y)
FFMPEG_AML_CONF_OPTS += --enable-nonfree
else
FFMPEG_AML_CONF_OPTS += --disable-nonfree
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_FFPLAY),y)
FFMPEG_AML_DEPENDENCIES += sdl2
FFMPEG_AML_CONF_OPTS += --enable-ffplay
FFMPEG_AML_CONF_ENV += SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl2-config
else
FFMPEG_AML_CONF_OPTS += --disable-ffplay
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_AVRESAMPLE),y)
FFMPEG_AML_CONF_OPTS += --enable-avresample
else
FFMPEG_AML_CONF_OPTS += --disable-avresample
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_FFPROBE),y)
FFMPEG_AML_CONF_OPTS += --enable-ffprobe
else
FFMPEG_AML_CONF_OPTS += --disable-ffprobe
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_POSTPROC),y)
FFMPEG_AML_CONF_OPTS += --enable-postproc
else
FFMPEG_AML_CONF_OPTS += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_SWSCALE),y)
FFMPEG_AML_CONF_OPTS += --enable-swscale
else
FFMPEG_AML_CONF_OPTS += --disable-swscale
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_AML_PROTOCOLS)),all)
FFMPEG_AML_CONF_OPTS += --disable-protocols \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_AML_PROTOCOLS)),--enable-protocol=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG_AML_FILTERS)),all)
FFMPEG_AML_CONF_OPTS += --disable-filters \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG_AML_FILTERS)),--enable-filter=$(x))
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_INDEVS),y)
FFMPEG_AML_CONF_OPTS += --enable-indevs
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FFMPEG_AML_CONF_OPTS += --enable-alsa
FFMPEG_AML_DEPENDENCIES += alsa-lib
else
FFMPEG_AML_CONF_OPTS += --disable-alsa
endif
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FFMPEG_AML_CONF_OPTS += --enable-libpulse
FFMPEG_AML_DEPENDENCIES += pulseaudio
endif
else
FFMPEG_AML_CONF_OPTS += --disable-indevs
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_OUTDEVS),y)
FFMPEG_AML_CONF_OPTS += --enable-outdevs
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FFMPEG_AML_DEPENDENCIES += alsa-lib
endif
else
FFMPEG_AML_CONF_OPTS += --disable-outdevs
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFMPEG_AML_CONF_OPTS += --enable-pthreads
else
FFMPEG_AML_CONF_OPTS += --disable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FFMPEG_AML_CONF_OPTS += --enable-zlib
FFMPEG_AML_DEPENDENCIES += zlib
else
FFMPEG_AML_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FFMPEG_AML_CONF_OPTS += --enable-bzlib
FFMPEG_AML_DEPENDENCIES += bzip2
else
FFMPEG_AML_CONF_OPTS += --disable-bzlib
endif

ifeq ($(BR2_PACKAGE_FDK_AAC)$(BR2_PACKAGE_FFMPEG_AML_NONFREE),yy)
FFMPEG_AML_CONF_OPTS += --enable-libfdk-aac
FFMPEG_AML_DEPENDENCIES += fdk-aac
else
FFMPEG_AML_CONF_OPTS += --disable-libfdk-aac
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_GPL)$(BR2_PACKAGE_LIBCDIO_PARANOIA),yy)
FFMPEG_AML_CONF_OPTS += --enable-libcdio
FFMPEG_AML_DEPENDENCIES += libcdio-paranoia
else
FFMPEG_AML_CONF_OPTS += --disable-libcdio
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
FFMPEG_AML_CONF_OPTS += --enable-gnutls --disable-openssl
FFMPEG_AML_DEPENDENCIES += gnutls
else
FFMPEG_AML_CONF_OPTS += --disable-gnutls
ifeq ($(BR2_PACKAGE_OPENSSL),y)
# openssl isn't license compatible with GPL
ifeq ($(BR2_PACKAGE_FFMPEG_AML_GPL)x$(BR2_PACKAGE_FFMPEG_AML_NONFREE),yx)
FFMPEG_AML_CONF_OPTS += --disable-openssl
else
FFMPEG_AML_CONF_OPTS += --enable-openssl
FFMPEG_AML_DEPENDENCIES += openssl
endif
else
FFMPEG_AML_CONF_OPTS += --disable-openssl
endif
endif

ifeq ($(BR2_PACKAGE_FFMPEG_AML_GPL)$(BR2_PACKAGE_LIBEBUR128),yy)
FFMPEG_AML_DEPENDENCIES += libebur128
endif

ifeq ($(BR2_PACKAGE_LIBDRM),y)
FFMPEG_AML_CONF_OPTS += --enable-libdrm
FFMPEG_AML_DEPENDENCIES += libdrm
else
FFMPEG_AML_CONF_OPTS += --disable-libdrm
endif

ifeq ($(BR2_PACKAGE_LIBOPENH264),y)
FFMPEG_AML_CONF_OPTS += --enable-libopenh264
FFMPEG_AML_DEPENDENCIES += libopenh264
else
FFMPEG_AML_CONF_OPTS += --disable-libopenh264
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
FFMPEG_AML_CONF_OPTS += --enable-vaapi
FFMPEG_AML_DEPENDENCIES += libva
else
FFMPEG_AML_CONF_OPTS += --disable-vaapi
endif

ifeq ($(BR2_PACKAGE_LIBVDPAU),y)
FFMPEG_AML_CONF_OPTS += --enable-vdpau
FFMPEG_AML_DEPENDENCIES += libvdpau
else
FFMPEG_AML_CONF_OPTS += --disable-vdpau
endif

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
FFMPEG_AML_CONF_OPTS += --enable-mmal --enable-omx --enable-omx-rpi \
	--extra-cflags=-I$(STAGING_DIR)/usr/include/IL
FFMPEG_AML_DEPENDENCIES += rpi-userland
else
FFMPEG_AML_CONF_OPTS += --disable-mmal --disable-omx --disable-omx-rpi
endif

# To avoid a circular dependency only use opencv if opencv itself does
# not depend on ffmpeg.
ifeq ($(BR2_PACKAGE_OPENCV_LIB_IMGPROC)x$(BR2_PACKAGE_OPENCV_WITH_FFMPEG),yx)
FFMPEG_AML_CONF_OPTS += --enable-libopencv
FFMPEG_AML_DEPENDENCIES += opencv
else ifeq ($(BR2_PACKAGE_OPENCV3_LIB_IMGPROC)x$(BR2_PACKAGE_OPENCV3_WITH_FFMPEG),yx)
FFMPEG_AML_CONF_OPTS += --enable-libopencv
FFMPEG_AML_DEPENDENCIES += opencv3
else
FFMPEG_AML_CONF_OPTS += --disable-libopencv
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
FFMPEG_AML_CONF_OPTS += --enable-libopus
FFMPEG_AML_DEPENDENCIES += opus
else
FFMPEG_AML_CONF_OPTS += --disable-libopus
endif

ifeq ($(BR2_PACKAGE_LIBVPX),y)
FFMPEG_AML_CONF_OPTS += --enable-libvpx
FFMPEG_AML_DEPENDENCIES += libvpx
else
FFMPEG_AML_CONF_OPTS += --disable-libvpx
endif

ifeq ($(BR2_PACKAGE_LIBASS),y)
FFMPEG_AML_CONF_OPTS += --enable-libass
FFMPEG_AML_DEPENDENCIES += libass
else
FFMPEG_AML_CONF_OPTS += --disable-libass
endif

ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
FFMPEG_AML_CONF_OPTS += --enable-libbluray
FFMPEG_AML_DEPENDENCIES += libbluray
else
FFMPEG_AML_CONF_OPTS += --disable-libbluray
endif

ifeq ($(BR2_PACKAGE_INTEL_MEDIASDK),y)
FFMPEG_AML_CONF_OPTS += --enable-libmfx
FFMPEG_AML_DEPENDENCIES += intel-mediasdk
else
FFMPEG_AML_CONF_OPTS += --disable-libmfx
endif

ifeq ($(BR2_PACKAGE_RTMPDUMP),y)
FFMPEG_AML_CONF_OPTS += --enable-librtmp
FFMPEG_AML_DEPENDENCIES += rtmpdump
else
FFMPEG_AML_CONF_OPTS += --disable-librtmp
endif

ifeq ($(BR2_PACKAGE_LAME),y)
FFMPEG_AML_CONF_OPTS += --enable-libmp3lame
FFMPEG_AML_DEPENDENCIES += lame
else
FFMPEG_AML_CONF_OPTS += --disable-libmp3lame
endif

ifeq ($(BR2_PACKAGE_LIBMODPLUG),y)
FFMPEG_AML_CONF_OPTS += --enable-libmodplug
FFMPEG_AML_DEPENDENCIES += libmodplug
else
FFMPEG_AML_CONF_OPTS += --disable-libmodplug
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
FFMPEG_AML_CONF_OPTS += --enable-libspeex
FFMPEG_AML_DEPENDENCIES += speex
else
FFMPEG_AML_CONF_OPTS += --disable-libspeex
endif

ifeq ($(BR2_PACKAGE_LIBTHEORA),y)
FFMPEG_AML_CONF_OPTS += --enable-libtheora
FFMPEG_AML_DEPENDENCIES += libtheora
else
FFMPEG_AML_CONF_OPTS += --disable-libtheora
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
FFMPEG_AML_CONF_OPTS += --enable-iconv
FFMPEG_AML_DEPENDENCIES += libiconv
else
FFMPEG_AML_CONF_OPTS += --disable-iconv
endif

# ffmpeg freetype support require fenv.h which is only
# available/working on glibc.
# The microblaze variant doesn't provide the needed exceptions
ifeq ($(BR2_PACKAGE_FREETYPE)$(BR2_TOOLCHAIN_USES_GLIBC)x$(BR2_microblaze),yyx)
FFMPEG_AML_CONF_OPTS += --enable-libfreetype
FFMPEG_AML_DEPENDENCIES += freetype
else
FFMPEG_AML_CONF_OPTS += --disable-libfreetype
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
FFMPEG_AML_CONF_OPTS += --enable-fontconfig
FFMPEG_AML_DEPENDENCIES += fontconfig
else
FFMPEG_AML_CONF_OPTS += --disable-fontconfig
endif

ifeq ($(BR2_PACKAGE_OPENJPEG),y)
FFMPEG_AML_CONF_OPTS += --enable-libopenjpeg
FFMPEG_AML_DEPENDENCIES += openjpeg
else
FFMPEG_AML_CONF_OPTS += --disable-libopenjpeg
endif

ifeq ($(BR2_PACKAGE_X264)$(BR2_PACKAGE_FFMPEG_AML_GPL),yy)
FFMPEG_AML_CONF_OPTS += --enable-libx264
FFMPEG_AML_DEPENDENCIES += x264
else
FFMPEG_AML_CONF_OPTS += --disable-libx264
endif

ifeq ($(BR2_PACKAGE_X265)$(BR2_PACKAGE_FFMPEG_AML_GPL),yy)
FFMPEG_AML_CONF_OPTS += --enable-libx265
FFMPEG_AML_DEPENDENCIES += x265
else
FFMPEG_AML_CONF_OPTS += --disable-libx265
endif

ifeq ($(BR2_PACKAGE_DAV1D),y)
FFMPEG_AML_CONF_OPTS += --enable-libdav1d
FFMPEG_AML_DEPENDENCIES += dav1d
else
FFMPEG_AML_CONF_OPTS += --disable-libdav1d
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
FFMPEG_AML_CONF_OPTS += --enable-x86asm
FFMPEG_AML_DEPENDENCIES += host-nasm
else
FFMPEG_AML_CONF_OPTS += --disable-x86asm
FFMPEG_AML_CONF_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FFMPEG_AML_CONF_OPTS += --enable-sse
else
FFMPEG_AML_CONF_OPTS += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
FFMPEG_AML_CONF_OPTS += --enable-sse2
else
FFMPEG_AML_CONF_OPTS += --disable-sse2
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
FFMPEG_AML_CONF_OPTS += --enable-sse3
else
FFMPEG_AML_CONF_OPTS += --disable-sse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
FFMPEG_AML_CONF_OPTS += --enable-ssse3
else
FFMPEG_AML_CONF_OPTS += --disable-ssse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
FFMPEG_AML_CONF_OPTS += --enable-sse4
else
FFMPEG_AML_CONF_OPTS += --disable-sse4
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
FFMPEG_AML_CONF_OPTS += --enable-sse42
else
FFMPEG_AML_CONF_OPTS += --disable-sse42
endif

ifeq ($(BR2_X86_CPU_HAS_AVX),y)
FFMPEG_AML_CONF_OPTS += --enable-avx
else
FFMPEG_AML_CONF_OPTS += --disable-avx
endif

ifeq ($(BR2_X86_CPU_HAS_AVX2),y)
FFMPEG_AML_CONF_OPTS += --enable-avx2
else
FFMPEG_AML_CONF_OPTS += --disable-avx2
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_ARM_CPU_ARMV4),y)
FFMPEG_AML_CONF_OPTS += --disable-armv5te
endif
ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
FFMPEG_AML_CONF_OPTS += --enable-armv6
else
FFMPEG_AML_CONF_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
FFMPEG_AML_CONF_OPTS += --enable-vfp
else
FFMPEG_AML_CONF_OPTS += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FFMPEG_AML_CONF_OPTS += --enable-neon
else ifeq ($(BR2_aarch64),y)
FFMPEG_AML_CONF_OPTS += --enable-neon
else
FFMPEG_AML_CONF_OPTS += --disable-neon
endif

ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
FFMPEG_AML_CONF_OPTS += --disable-mipsfpu
else
FFMPEG_AML_CONF_OPTS += --enable-mipsfpu
endif

# Fix build failure on "addi opcode not supported"
ifeq ($(BR2_mips_32r6)$(BR2_mips_64r6),y)
FFMPEG_AML_CONF_OPTS += --disable-asm
endif
endif # MIPS

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
FFMPEG_AML_CONF_OPTS += --enable-altivec
else
FFMPEG_AML_CONF_OPTS += --disable-altivec
endif

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
FFMPEG_AML_CONF_OPTS += --extra-libs=-latomic
endif

ifeq ($(BR2_STATIC_LIBS),)
FFMPEG_AML_CONF_OPTS += --enable-pic
else
FFMPEG_AML_CONF_OPTS += --disable-pic
endif

# Default to --cpu=generic for MIPS architecture, in order to avoid a
# warning from ffmpeg's configure script.
ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
FFMPEG_AML_CONF_OPTS += --cpu=generic
else ifneq ($(GCC_TARGET_CPU),)
FFMPEG_AML_CONF_OPTS += --cpu="$(GCC_TARGET_CPU)"
else ifneq ($(GCC_TARGET_ARCH),)
FFMPEG_AML_CONF_OPTS += --cpu="$(GCC_TARGET_ARCH)"
endif

FFMPEG_AML_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
FFMPEG_AML_CONF_OPTS += --disable-optimizations
FFMPEG_AML_CFLAGS += -O0
endif

FFMPEG_AML_CONF_ENV += CFLAGS="$(FFMPEG_AML_CFLAGS)"
FFMPEG_AML_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_FFMPEG_AML_EXTRACONF))

define FFMPEG_AML_REMOVE_LIBRARY_FILES
	rm -rf $(TARGET_DIR)/usr/lib/libavcodec*
	rm -rf $(TARGET_DIR)/usr/lib/libavdevice*
	rm -rf $(TARGET_DIR)/usr/lib/libavfilter*
	rm -rf $(TARGET_DIR)/usr/lib/libavformat*
	rm -rf $(TARGET_DIR)/usr/lib/libavutil*
	rm -rf $(TARGET_DIR)/usr/lib/libswresample*
	rm -rf $(TARGET_DIR)/usr/lib/libswscale*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libavcodec*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libavdevice*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libavfilter*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libavformat*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libavutil*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libswresample*
	rm -rf $(HOST_DIR)/arm-linux-gnueabihf/sysroot/usr/lib/libswscale*
endef

FFMPEG_AML_PRE_BUILD_HOOKS += FFMPEG_AML_REMOVE_LIBRARY_FILES

# Override FFMPEG_AML_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_AML_CONFIGURE_CMDS
	(cd $(FFMPEG_AML_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG_AML_CONF_ENV) \
	./configure \
		--enable-cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		--disable-stripping \
		--pkg-config="$(PKG_CONFIG_HOST_BINARY)" \
		--extra-cflags="-DAMFFMPEG" \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG_AML_CONF_OPTS) \
	)
endef

define FFMPEG_AML_REMOVE_EXAMPLE_SRC_FILES
	rm -rf $(TARGET_DIR)/usr/share/ffmpeg/examples
endef
FFMPEG_AML_POST_INSTALL_TARGET_HOOKS += FFMPEG_AML_REMOVE_EXAMPLE_SRC_FILES

$(eval $(autotools-package))
