# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games eutils versionator

MY_PV=$(replace_all_version_separators '_' )
#MY_PV=$(replace_version_separator '_' )
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Freespace2 SCP"
HOMEPAGE="http://scp.indiegames.us/"

SRC_URI="http://swc.fs2downloads.com/builds/${MY_P}.tgz"
#http://freespace.pl/hosted/foxer/gtva_ico/gtva.ico

#iconos: http://www.hard-light.net/forums/index.php?topic=44371.20

#SRC_URI="http://swc.fs2downloads.com/builds/${PN}_3_6_10.tgz"
#	videos? ( http://fszmirror.com/files/FS2OGGcutscenepack.vp )"

S=${WORKDIR}/${MY_P}

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="mediavps speech videos yal"
IUSE="babylon freespace2 inferno speech"
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
	freespace2?	( =games-action/freespace2-mediavps-${PV}
			games-action/freespace2-data )
	babylon?	( games-action/babylon-mediavps )"
#	yal? ( games-action/fs2_launcher )"

DEPEND="${RDEPEND}"

dir=${GAMES_DATADIR}/${PN}

pkg_setup() {
	if useq babylon && useq freespace2 ; then
               eerror "Error: 'freespace2' and 'babylon' USE flags cannot both be enabled!"
               die
	fi
#	if use babylon && ! use inferno; then
#               elog "Please, for full advantage of TBP mod, enable inferno useflag too!"
#               die
#	fi
}

if useq freespace2 ; then
        FS2DATA=${GAMES_PREFIX_OPT}/freespace2
fi
if useq babylon ; then
        FS2DATA=${GAMES_PREFIX_OPT}/babylon
fi

src_compile() {
    chmod +x ${S}/autogen.sh
    ${S}/autogen.sh 2>&1 > /dev/null
    if [ -x ./configure ]; then
        econf \
	$(use_enable speech ) \
	$(use_enable inferno )
    fi
    if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
        emake || die "emake failed"
    fi
}


src_install() {
	exeinto "${dir}"
	newexe code/${PN}_r ${PN} || die

	if useq babylon || useq freespace2; then
		games_make_wrapper ${PN} "${dir}"/${PN} "${FS2DATA}"
	fi

#    if useq videos ; then
#		insinto "${FS2DATA}/data/"
#		doins "${DISTDIR}"/FS2OGGcutscenepack.vp || die
#    fi

	dodoc AUTHORS ChangeLog COPYING NEWS README FS2OpenSCPReadMe.doc
	newicon code/freespace2/app_icon.png fs2_open.png
	#newicon /usr/portage/distfiles/gtva.ico fs2_open.ico
	make_desktop_entry ${PN} "${DESCRIPTION}" fs2_open

	prepgamesdirs

	if use babylon && ! use inferno; then
		elog "Please, for full advantage of TBP mod, enable inferno useflag too and rebuild!"
        fi
}
