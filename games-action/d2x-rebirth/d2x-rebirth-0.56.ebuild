# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games scons-utils

DESCRIPTION="Descent Rebirth - enhanced Descent 2 engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="mirror://sourceforge/dxx-rebirth/${PN}_v${PV}-src.tar.gz
		linguas_de? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-briefings-ger.zip )
		music? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.zip )"
LICENSE="D1X GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall debug ipv6 linguas_de music opengl"

DEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl[audio,opengl?,video]
	media-libs/sdl-mixer
	opengl? ( virtual/opengl virtual/glu )"
RDEPEND="${DEPEND}
	cdinstall? ( games-action/descent2-data )
	!cdinstall? ( games-action/descent2-demodata )"

S=${WORKDIR}/${PN}_v${PV}-src

src_prepare() {
	# Patch in upstream vcs, won't be needed once 0.57 is released
	# http://dxx-rebirth.bzr.sourceforge.net/bzr/dxx-rebirth/d2x-rebirth/revision/923	
	epatch "${FILESDIR}"/${P}-printf-fix.patch || die
}

src_compile() {
	scons ${MAKEOPTS} \
		verbosebuild=1 \
		sharepath="${GAMES_DATADIR}/d2x" \
		sdlmixer=1 \
		$(use_scons debug) \
		$(use_scons !opengl sdl_only) \
		$(use_scons ipv6) \
		|| die
}

src_install() {
	edos2unix INSTALL.txt README.txt
	dodoc INSTALL.txt README.txt || die

	# These zip files do not need to be extracted
	insinto "${GAMES_DATADIR}/d2x"

	if use linguas_de ; then
		doins "${DISTDIR}"/d2xr-briefings-ger.zip || die
	fi
	if use music ; then
		doins "${DISTDIR}"/d2xr-sc55-music.zip || die
	fi

	doicon ${PN}.xpm || die

	if use opengl ; then
		newgamesbin d2x-rebirth-gl d2x-rebirth || die
	else
		newgamesbin d2x-rebirth-sdl d2x-rebirth || die
	fi
	make_desktop_entry d2x-rebirth "Descent 2 Rebirth" ${PN} || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall ; then
		elog "The Descent 2 Demo data has been installed."
		elog "To play the full game enable USE=\"cdinstall\" or manually copy "
		elog "the files to ${GAMES_DATADIR}/d2x."
		elog "Read /usr/share/doc/${PF}/INSTALL.txt for details."
	fi

	if use music ; then
		einfo "Please note, the music is disabled by default."
		einfo "You can switch it on using the in-game menus"
	fi
}
