# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ltprune versionator git-r3 cmake-utils gnome2-utils

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator, with PXGP modification"
HOMEPAGE="https://github.com/iCatButler/pcsxr"

EGIT_REPO_URI="https://github.com/iCatButler/pcsxr"
#EGIT_BRANCH="fix-linux-build"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="sio1 opengl nls joystick x86"

RDEPEND="
	dev-libs/glib:2=
	media-libs/libsdl2:0=[joystick]
	sys-libs/zlib:0=
	x11-libs/gtk+:3=
	x11-libs/libX11:0=
	x11-libs/libXv:0=
	opengl? ( virtual/opengl:0=
		x11-libs/libXxf86vm:0= )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/intltool
	x11-proto/videoproto
	nls? ( sys-devel/gettext:0 )
	x86? ( dev-lang/nasm )
	!games-emulation/pcsxr
"


src_configure() {
	local myconf=(
		$(use_enable sio1 BUILD_SIO1)
		$(use_enable opengl BUILD_OPENGL)
	)
	cmake-utils_src_configure $myconf
}

src_install() {
	cmake-utils_src_install
	prune_libtool_files --all

	dodoc doc/{keys,tweaks}.txt
}

pkg_postinst() {
	gnome2_icon_cache_update
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
