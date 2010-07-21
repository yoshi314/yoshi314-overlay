# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="Artwork and models that greatly enhance the graphics of Freespace 2"
IUSE="adveffects assets effects music yal"
KEYWORDS="~amd64 ~x86"
SLOT="0"

HOMEPAGE="http://scp.indiegames.us/"
FSMODS="http://www.freespacemods.net/files/MVP3610"
SRC_URI="${FSMODS}/MV_Core.zip
	${FSMODS}/3610_Patch.zip
	music?   ( ${FSMODS}/MV_Music.zip )
	assets?  ( ${FSMODS}/MV_Assets.zip )
	effects? ( ${FSMODS}/MV_Effects.zip )
	adveffects? ( ${FSMODS}/MV_Advanced.zip )"

LICENSE="as-is"

RDEPEND="games-action/freespace2-data
	yal? ( games-action/fs2_launcher )"

DEPEND="app-arch/unzip
	app-arch/unrar"

S=${WORKDIR}

#pkg_setup() {
#	if useq cell && useq adveffects ; then
#		eerror "Error: 'cell' and 'adveffects' USE flags cannot both be enabled!"
#		die
#	fi
#}

src_install() {
    insinto "${GAMES_PREFIX_OPT}/freespace2/mediavps"
    doins *.vp || die
    doins FSU-MVP.bmp || die
    doins mod.ini || die
    dodoc readme.txt || die
    if useq yal ; then
                dosym ${GAMES_DATADIR}/fs2_open/fs2_open ${GAMES_PREFIX_OPT}/freespace2/fs2_open
    fi
    prepgamesdirs
}

