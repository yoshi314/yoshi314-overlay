# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Snes9X core for libretro emulation system"
HOMEPAGE="http://github.com/snes9xgit/snes9x"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/snes9xgit/snes9x.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

inherit git-2 games multilib

src_unpack() {
    git-2_src_unpack
}

src_compile() { 
    cd "${S}/libretro"
    make  || die "Failed to build"
}

src_install() {
    cd "${S}/libretro"
    mv libretro.so libretro-s9x.so
    insinto $(games_get_libdir)/libretro
    doins libretro-s9x.so
}