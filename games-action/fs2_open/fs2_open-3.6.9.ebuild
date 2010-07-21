# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="Freespace 2 Source Code Project"
HOMEPAGE="http://scp.indiegames.us/"

WARP="http://fs2source.warpcore.org"
SRC_URI="${WARP}/exes/linux/${P}.tar.bz2
	videos? ( http://fszmirror.com/files/FS2OGGcutscenepack.vp )"

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="videos mediavps"
RESTRICT="mirror"

RDEPEND="media-libs/libogg
	>=media-libs/libsdl-1.2
	media-libs/libvorbis
    media-libs/libtheora
	media-libs/openal
	virtual/opengl
	|| (
		(	media-libs/mesa
			x11-libs/libX11
			x11-libs/libXau
			x11-libs/libXdmcp
			x11-libs/libXext )
		virtual/x11 )
	mediavps? ( =games-action/freespace2-mediavps-${PV} )
	games-action/freespace2-data"
DEPEND="${RDEPEND}"

dir=${GAMES_DATADIR}/${PN}
FS2DATA=${GAMES_PREFIX_OPT}/freespace2

src_install() {
	exeinto "${dir}"
	newexe code/${PN}_r ${PN} || die
	games_make_wrapper ${PN} "${dir}"/${PN} "${FS2DATA}"

    if useq videos ; then
		insinto "${FS2DATA}/data/"
		doins "${DISTDIR}"/FS2OGGcutscenepack.vp || die
    fi

	dodoc AUTHORS ChangeLog NEWS README

	make_desktop_entry ${PN} "${DESCRIPTION}"

	prepgamesdirs
}
