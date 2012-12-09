# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 games multilib

DESCRIPTION="Mednafen core for libretro emulation system"
HOMEPAGE="http://github.com/libretro/mednafen-libretro"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/libretro/mednafen-libretro.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

cores="psx pce-fast wswan ngp gba snes vb"

for core in ${cores} ; do
    IUSE="$IUSE +core_${core}"
done

src_unpack() {
    git-2_src_unpack
}

src_compile() { 
    for core in ${cores} ; do
	if use core_${core} ; then
            cd "${S}/${core}"
            make core=${core} || die "Failed to build ${core}"
        fi
    done
}

src_install() {
    for core in ${cores} ; do
	if use core_${core} ; then
            cd "${S}"/${core}
            mv -v libretro.so libretro-${core}.so
            insinto $(games_get_libdir)/libretro
	    doins libretro-${core}.so
	fi
    done
}