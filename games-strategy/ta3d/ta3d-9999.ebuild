# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games subversion cmake-utils

DESCRIPTION="Ta3d - Classic Total Annihilation with refreshed graphics."
HOMEPAGE="http://ta3d.org"
#SRC_URI=""
ESVN_REPO_URI="http://svn.ta3d.org/ta3d/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/sdl-image
	media-libs/sdl-net
	media-libs/sdl-mixer
	media-libs/glew
	media-libs/smpeg
	media-libs/freetype:2"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

CMAKE_USE_DIR=${S}/src
CMAKE_BUILD_DIR=${CMAKE_USE_DIR}

src_unpack() {
        subversion_src_unpack
}

src_prepare() {
        subversion_src_prepare
}


src_configure() {
#	cd ${CMAKE_USE_DIR}
        local mycmakeargs="
                -Dbindir=${GAMES_BINDIR}
                -Ddatadir=${GAMES_DATADIR}/${PN}
                -Dlibdir=$(games_get_libdir)/${PN}"

	cmake-utils_src_configure
}

src_install() {
	mkdir -p ${D}/usr/games/bin
	cmake-utils_src_install
	prepgamesdirs
	
	#this is stupid, but i have no better idea on how to fix this for now
	mv ${D}/usr/games/ta3d ${D}/usr/games/bin/ta3d
}

pkg_postinst() {
	games_pkg_postinst
	elog "Install the game data herp derp"
}

