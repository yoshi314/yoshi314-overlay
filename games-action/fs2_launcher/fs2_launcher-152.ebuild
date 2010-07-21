# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games subversion eutils

DESCRIPTION="Yal fs2_launcher"
HOMEPAGE="http://scp.indiegames.us/"

ESVN_REPO_URI="svn://vega.livecd.pl/yal/trunk@${PV}"
ESVN_BOOTSTRAP="build-all.sh"

#SRC_URI="http://swc.fs2downloads.com/builds/${MY_P}.tgz"

S=${WORKDIR}/${P}

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="babylon freespace2"
RESTRICT="mirror"

#	QT4 >= 4.3
#	SDL >= 1.2.13
#	OpenAL (openal-soft recommended!)


RDEPEND="media-libs/openal
	>=media-libs/libsdl-1.2.13
	>=x11-libs/qt-core-4.3"

DEPEND="${RDEPEND}"

dir=${GAMES_DATADIR}/${PN}
dir=${GAMES_PREFIX_OPT}/freespace2

if useq babylon ; then
	dir=${GAMES_PREFIX_OPT}/babylon
fi
if useq freespce2 ; then
	dir=${GAMES_PREFIX_OPT}/freespace2
fi

src_install() {

	#donde se instalara
	exeinto "${dir}"
	#que instalo
	doexe bin/${PN} || die
#	newexe bin/${PN} ${PN} || die
	dosym ${dir}/${PN} ${GAMES_BINDIR}/${PN}
#	games_make_wrapper ${PN} "${dir}"/${PN} "${FS2DATA}"

	dodoc AUTHORS ChangeLog README

        newicon resources/fs2.ico fs2_launcher.ico
        make_desktop_entry ${PN} "${DESCRIPTION}" fs2_launcher.ico
	
	elog "${PN} was placed in ${dir}"

#	prepgamesdirs
}

