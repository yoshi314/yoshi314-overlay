# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune versionator git-r3 cmake-utils

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator, with PXGP modification"
HOMEPAGE="https://github.com/iCatButler/pcsxr"

EGIT_REPO_URI="https://github.com/iCatButler/pcsxr"
#EGIT_BRANCH="fix-linux-build"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa cdio ffmpeg libav nls openal opengl oss pulseaudio +sdl"
REQUIRED_USE="?? ( alsa openal oss pulseaudio sdl )"

RDEPEND="
	dev-libs/glib:2=
	media-libs/libsdl:0=[joystick]
	sys-libs/zlib:0=
	x11-libs/gtk+:3=
	x11-libs/libX11:0=
	x11-libs/libXext:0=
	x11-libs/libXtst:0=
	x11-libs/libXv:0=
	alsa? ( media-libs/alsa-lib:0= )
	cdio? ( dev-libs/libcdio:0= )
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3:0= )
		libav? ( media-video/libav:0= ) )
	nls? ( virtual/libintl:0= )
	openal? ( media-libs/openal:0= )
	opengl? ( virtual/opengl:0=
		x11-libs/libXxf86vm:0= )
	pulseaudio? ( media-sound/pulseaudio:0= )
	sdl? ( media-libs/libsdl2:0=[sound] )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/intltool
	x11-proto/videoproto
	nls? ( sys-devel/gettext:0 )
	x86? ( dev-lang/nasm )
	!games-emulation/pcsxr
"

# it's only the .po file check that fails :)
RESTRICT=test

#	"${FILESDIR}"/${P}-disable-sdl2.patch
#	"${FILESDIR}"/${P}-ffmpeg3.patch


#PATCHES=(
#	"${FILESDIR}"/${P}-zlib-uncompress2.patch
#)

#S="${WORKDIR}/${PN}"

src_prepare() {
	./autogen.sh
	default
#	eautoreconf
}

src_configure() {
	local sound_backend

	if use alsa; then
		sound_backend=alsa
	elif use oss; then
		sound_backend=oss
	elif use pulseaudio; then
		sound_backend=pulseaudio
	elif use sdl; then
		sound_backend=sdl
	elif use openal; then
		sound_backend=openal
	else
		sound_backend=null
	fi

	local myconf=(
		$(use_enable nls)
		$(use_enable cdio libcdio)
		$(use_enable opengl)
		$(use_enable ffmpeg ccdda)
		--enable-sound=${sound_backend}
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	prune_libtool_files --all

	dodoc doc/{keys,tweaks}.txt
}

pkg_postinst() {
	local vr
	for vr in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 1.9.94-r1 ${vr}; then
			ewarn "Starting with pcsxr-1.9.94-r1, the plugin install path has changed."
			ewarn "In order for pcsxr to find plugins, you will need to remove stale"
			ewarn "symlinks from ~/.pcsxr/plugins. You can do this using the following"
			ewarn "command (as your regular user):"
			ewarn
			ewarn " $ find ~/.pcsxr/plugins/ -type l -delete"
		fi
	done
}
