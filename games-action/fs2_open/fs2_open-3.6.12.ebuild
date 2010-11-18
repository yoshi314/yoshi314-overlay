# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit games eutils versionator

MY_PV=$(replace_all_version_separators '_' )
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Freespace2 SCP"
HOMEPAGE="http://scp.indiegames.us/"

SRC_URI="http://swc.fs2downloads.com/builds/${MY_P}.tgz"
	videos? ( http://swc.fs2downloads.com/files/FS2OGGCutscenepack.vp )"

S=${WORKDIR}/${MY_P}

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="mediavps speech videos yal"
IUSE="debug babylon freespace2 inferno speech videos"
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

DEPEND="${RDEPEND}"

dir=${GAMES_DATADIR}/${PN}

if useq freespace2 ; then
	FS2DATA=${GAMES_PREFIX_OPT}/freespace2
fi
if useq babylon ; then
	TBPDATA=${GAMES_PREFIX_OPT}/babylon
fi

src_compile() {
	chmod +x ${S}/autogen.sh
	if useq debug ; then
		NOCONFIGURE=1 ${S}/autogen.sh --enable-debug 2>&1 > /dev/null
	else
		NOCONFIGURE=1 ${S}/autogen.sh 2>&1 > /dev/null
	fi
	if [ -x ./configure ]; then
		econf \
	$(use_enable debug ) \
	$(use_enable speech ) \
	$(use_enable inferno )
	fi
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake || die "emake failed"
	fi
}

src_install() {
	exeinto "${dir}"

	newicon code/freespace2/app_icon.png fs2_open.png

	if useq babylon; then
		sed -e "s/.fs2_open/.babylon5/g" code/${PN}_r > code/babylon || die "Hardcoding binary failed"
		newexe code/babylon babylon || die "Copying binary failed"
		games_make_wrapper babylon "${dir}"/babylon "${TBPDATA}" || die "Making wrapper failed"
		make_desktop_entry babylon "The babylon project" || die "Making desktop entry failed"
	fi
	if useq freespace2; then
		doexe code/${PN} || die "Copying binary failed"
		games_make_wrapper ${PN} "${dir}"/${PN} "${FS2DATA}" || die "Making wrapper failed"
		make_desktop_entry ${PN} "Freespace2 project" || die "Making desktop entry failed"
	fi

	if useq videos ; then
		insinto "${FS2DATA}/data/"
		doins "${DISTDIR}"/FS2OGGCutscenepack.vp || die
	fi

	dodoc AUTHORS ChangeLog COPYING NEWS README FS2OpenSCPReadMe.doc

	prepgamesdirs

}

pkg_postinst() {
	if use babylon && ! use inferno; then
		elog "Please, for full advantage of TBP, enable inferno useflag too and rebuild!"
	fi

	elog "If you are rebuilding this package, you have to rebuild fs2_launcher too"
}
