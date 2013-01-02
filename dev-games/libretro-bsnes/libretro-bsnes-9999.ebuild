# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="BSNES core for libretro emulation system"
HOMEPAGE="http://byuu.org/bsnes"
EGIT_REPO_URI="git://gitorious.org/bsnes/bsnes.git"
EGIT_BRANCH=libretro

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

cores="performance compatibility accuracy"

for core in ${cores} ; do
    IUSE="$IUSE +core_${core}"
done

DEPEND=""
RDEPEND="${DEPEND}"

inherit git-2 games multilib

src_unpack() {
    git-2_src_unpack
    cd ${S}
    
}

src_compile() { 
	mkdir "${S}/build"
	cd "${S}/bsnes"

    for core in ${cores} ; do
		if use core_${core} ; then
			einfo "Building ${core} core ... "
            make compiler=gcc ui=target-libretro profile=${core} || die "Failed to build core ${core}"
            cp out/libretro.so ${S}/build/libretro-bsnes-${core}.so
		fi
    done

}

src_install() {
    cd "${S}"/build
    insinto $(games_get_libdir)/libretro
    doins *.so
}
