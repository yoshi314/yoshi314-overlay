# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="The Babylon Project is stand-alone and does not need original Freespace 2 to work"
IUSE="campaigns yal"
KEYWORDS="~amd64 ~x86"
SLOT="0"

HOMEPAGE="http://babylon.hard-light.net/official_downloads.php"
FSMODS="http://freespacemods.net/e107_files/downloads"
SRC_URI="${FSMODS}/2009_07_31_Zathras.1.rar
	${FSMODS}/TheBabylonProject.7z
	campaigns? ( ${FSMODS}/tbp-cpack-2.0.7z )"

LICENSE="as-is"

#RDEPEND="games-action/fs2_open[inferno]"
RDEPEND="app-arch/unzip
	app-arch/unrar
	app-arch/p7zip
        yal? ( games-action/fs2_launcher )"

DEPEND="${RDEPEND}"

S=${WORKDIR}

#pkg_setup() {
#	if useq cell && useq adveffects ; then
#		eerror "Error: 'cell' and 'adveffects' USE flags cannot both be enabled!"
#		die
#	fi
#}

src_install() {
	fdir=${S}/"The Babylon Project"
	insinto "${GAMES_PREFIX_OPT}/babylon"
	doins "${fdir}"/{*.vp,*.cfg,*.ogg} || die
	insinto "${GAMES_PREFIX_OPT}/babylon/data"
	doins -r "${fdir}"/data/{cache,missions,strips,tables} || die
	doins "${fdir}"/data/*.cfg	 || die
	
	insinto "${GAMES_PREFIX_OPT}/babylon"
	fdir=${S}/"Zathras"
        doins "${fdir}"/{*.vp,*.bmp,*.ini} || die
	
	if useq campaigns ; then
		fdir=${S}/"tbp"
		insinto "${GAMES_PREFIX_OPT}/babylon"
		doins "${fdir}"/{*.vp,*.avi,*.ogg} || die
		insinto "${GAMES_PREFIX_OPT}/babylon/data"
		doins -r "${fdir}"/data/{missions,voice} || die
	fi
	if useq yal ; then
		dosym ${GAMES_DATADIR}/fs2_open/fs2_open ${GAMES_PREFIX_OPT}/babylon/fs2_open
        fi

#falta hacer el parche para que yal pille el directorio correcto en cada mod
#dohtml
#dodoc
#doicon
#    doins *.vp *.avi *.ogg || die
#    dodoc readme.txt || die
    prepgamesdirs
}

