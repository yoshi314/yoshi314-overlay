# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="The Freespace 2 Source Code Project"
HOMEPAGE="http://scp.indiegames.us/"
SRC_URI="http://icculus.org/~taylor/fso/releases/${P}.tar.bz2"

LICENSE="FS2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/x11
	media-libs/libsdl
	media-libs/openal
	virtual/opengl"

src_install() {
	FS2DIR=${GAMES_PREFIX_OPT}/${PN}

	exeinto ${FS2DIR}
	doexe code/fs2_open_r
	dodoc README AUTHORS ChangeLog NEWS INSTALL
	games_make_wrapper fs2_open ./fs2_open_r ${FS2DIR}

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	
	einfo "Copy the data files from a FreeSpace 2 Windows full installation"
	einfo "into ${FS2DIR}"
	einfo ""
	einfo "  Example: cp -r /mnt/winc/Games/FreeSpace2/* ${FS2DIR}"
	echo
	einfo "You can change resolution from (640x480)x16 to (1024x768)x32 if you edit"
	einfo " ~/.fs2open/fs2_open.ini (created on the first run)"
	echo
}
