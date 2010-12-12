# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit games subversion eutils

DESCRIPTION="Yal fs2_launcher"
HOMEPAGE="http://scp.indiegames.us/"

ESVN_REPO_URI="svn://vega.livecd.pl/yal/trunk@${PV}"
ESVN_BOOTSTRAP="build-all.sh"

S=${WORKDIR}/${P}

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="babylon freespace2"
IUSE=""
RESTRICT="mirror"

#	QT4 >= 4.3
#	SDL >= 1.2.13
#	OpenAL (openal-soft recommended!)

RDEPEND="media-libs/openal
	>=media-libs/libsdl-1.2.13
	>=x11-libs/qt-core-4.3
	games-action/fs2_open"

DEPEND="${RDEPEND}"

#dir=${GAMES_DATADIR}/${PN}
#dir=${GAMES_PREFIX_OPT}/freespace2

src_install() {

	newicon resources/fs2.ico fs2_launcher.png

	if has_version games-action/fs2_open[babylon] ; then
		dir=${GAMES_PREFIX_OPT}/babylon
		elog "Building launcher for babylon"
		exeinto "${dir}"
		#"324s/fs2_open/babylon2/g"
		sed -e "s/fs2_open/babylon5/g" bin/${PN} > bin/babylon_launcher || die "Hardcoding binary failed"
		newexe bin/babylon_launcher babylon_launcher || die "doexe failed"
		dosym ${dir}/babylon_launcher ${GAMES_BINDIR}/babylon_launcher || die "dosym failed"
		#nombre del binario,descripcion para el menu y nombre del icono
		make_desktop_entry babylon_launcher "Yal babylon launcher" || die "Desktop entry failed"
	fi
	if has_version games-action/fs2_open[freespace2] ; then
		dir=${GAMES_PREFIX_OPT}/freespace2
		elog "Building launcher for freespace2"
		exeinto "${dir}"
		# sed -e "s/fs2_open/freespc2/g" bin/${PN} > bin/${PN}_r2 || die "Hardcoding binary failed"
		doexe bin/${PN} || die "doexe failed"
		dosym ${dir}/${PN} ${GAMES_BINDIR}/${PN} || die "dosym failed"

		make_desktop_entry ${PN} "Yal freespace2 launcher" || die "Desktop entry failed"
	fi
	dodoc AUTHORS ChangeLog README
}

