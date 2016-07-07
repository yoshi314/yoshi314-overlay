# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games cmake-utils eutils subversion

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code that also supports Heretic, Hexen, and Strife"
HOMEPAGE="http://grafzahl.drdteam.org/"
#SRC_URI="http://omploader.org/vNjdnZw/${P}.tar.bz2"
ESVN_REPO_URI="http://mancubus.net/svn/hosted/gzdoom/tags/${PV}"

SRC_URI="amd64? ( http://www.fmod.org/index.php/release/version/fmodapi42816linux64.tar.gz )
x86? ( http://www.fmod.org/index.php/release/version/fmodapi42816linux.tar.gz )"



LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mmx gtk fluidsynth"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	fluidsynth? ( media-sound/fluidsynth )
	media-libs/flac
	media-libs/fmod:1
	virtual/glu
	virtual/jpeg
	virtual/opengl
	media-libs/libsdl"

use amd64 && FMODURI="fmodapi42816linux64.tar.gz"
use x86   && FMODURI="fmodapi42816linux.tar.gz"

_fmodversion=4.28.16

_fmodsuffix=""
use amd64 && _fmodsuffix="64"

DEPEND="${REPEND}
	mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_prepare() {
	# Use default game data path"
	sed -i \
		-e "s:/usr/local/share/:${GAMES_DATADIR}/doom-data/:" \
		src/sdl/i_system.h || die
	epatch "${FILESDIR}/${PN}-respect-fluidsynth-useflag.patch"
	tar xvzf ${DISTDIR}/${FMODURI} -C ${WORKDIR}
	
#	cp ${WORKDIR}/fmodapi${_fmodversion//./}linux${_fmodsuffix}/api/lib/libfmodex${_fmodsuffix}-${_fmodversion}.so ${WORKDIR}/${P}/libfmodex-${PN}.so || die "failed to link fmod"
	
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		$(cmake-utils_use_use fluidsynth FLUIDSYNTH)
		-DFMOD_INCLUDE_DIR=${WORKDIR}/fmodapi${_fmodversion//./}linux${_fmodsuffix}/api/inc
		-DFMOD_LIBRARY=${WORKDIR}/fmodapi${_fmodversion//./}linux${_fmodsuffix}/api/lib/libfmodex${_fmodsuffix}-${_fmodversion}.so
	)

	cmake-utils_src_configure
}

src_install() {
	dodoc docs/*.{txt,TXT} || die
	dohtml docs/console*.{css,html} || die

	cd "${CMAKE_BUILD_DIR}" || die
	dogamesbin ${PN} || die
	dogameslib ${WORKDIR}/fmodapi${_fmodversion//./}linux${_fmodsuffix}/api/lib/libfmodex${_fmodsuffix}-${_fmodversion}.so

	insinto "${GAMES_DATADIR}/doom-data"
	doins ${PN}.pk3 || die

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Copy or link wad files into ${GAMES_DATADIR}/doom-data/"
	elog "(the files must be readable by the 'games' group)."
	elog
	elog "To play, simply run:"
	elog "   gzdoom"
	elog
	if use fluidsynth && ! has_version media-sound/fluid-soundfont; then
		ewarn "You may need to install media-sound/fluid-soundfont"
		ewarn "for fluidsynth to play music, depending on your sound card."
	fi
	elog "See /usr/share/doc/${P}/zdoom.txt.bz2 for more info"
}
