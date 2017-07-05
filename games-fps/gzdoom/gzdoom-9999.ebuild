# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils games cmake-utils git-2

DESCRIPTION="Enhanced OpenGL port of the official DOOM source code that also supports Heretic, Hexen, and Strife"
HOMEPAGE="http://grafzahl.drdteam.org/"
EGIT_REPO_URI="https://github.com/coelckers/gzdoom.git"

LICENSE="DOOMLIC BUILDLIC BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mmx gtk"

RDEPEND="
	mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )
	gtk? ( x11-libs/gtk+:2 )
	media-libs/libsdl
	media-libs/fmod:1
	media-libs/flac
	virtual/jpeg
	media-sound/fluidsynth
"

ZDOOM_DIR="${GAMES_DATADIR}/${PN}"

src_prepare() {
	# Use default game data path.
	einfo "Fixing the file path in src/sdl/i_system.h."
	sed -ie "s:/usr/local/share/:${ZDOOM_DIR}/:" src/posix/i_system.h 
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no mmx ASM)
		$(cmake-utils_use_no gtk GTK)
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)
	cmake-utils_src_configure
}

src_install() {
	# Does anyone really care about the docs?
	dodoc docs/*.txt 
	dohtml docs/console*.{css,html} 

	# Binary.
	cd "${CMAKE_BUILD_DIR}" 
	dogamesbin ${PN} 

	# Install zdoom.pk3.
	insinto ${ZDOOM_DIR}
	doins ${PN}.pk3 

	# So make a desktop entry.
	doicon ${FILESDIR}/${PN}.png
	make_desktop_entry ${PN} "GZDoom"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "Before you can play ${PN}, you must do one of the following:"
	elog " - Copy or link IWAD files into ${ZDOOM_DIR}"
	elog "    (The files must be readable by the 'games' group)."
	elog " - Add your IWAD directory to your ~/.${PN}/zdoom.ini"
	elog "    file in the [IWADSearch.Directories] section."
	elog " - Start ${PN} with the -iwad <iwadpath> option."
	elog
	elog "To play, run: \"${PN}\" (and add options and stuff)"
}

