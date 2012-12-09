# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="VisualBoy Advance core for libretro emulation system"
HOMEPAGE="http://github.com/libretro/vba-next"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/libretro/vba-next.git"

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
    cd "${S}"
    make -f Makefile.libretro || die "Failed to build"
}

src_install() {
    cd "${S}"
    mv libretro.so libretro-vba.so
    insinto $(games_get_libdir)/libretro
    doins libretro-vba.so
}