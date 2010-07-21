# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="Artwork and models that greatly enhance the graphics of Freespace 2"
IUSE="cell adveffects"
KEYWORDS="~amd64 ~x86"
SLOT="0"

HOMEPAGE="http://scp.indiegames.us/"
WARP="http://fs2source.warpcore.org"
SRC_URI="${WARP}/mvp368zeta/mv_core.zip
	${WARP}/mvp368zeta/mv_music.zip
	cell? ( ${WARP}/mvp368zeta/mv_cell.zip )
	!cell? ( 
		${WARP}/mvp368zeta/mv_textures.zip
		${WARP}/mvp368zeta/mv_models.zip
		${WARP}/mediavp/mp-710_models.rar
		${WARP}/mvp368zeta/mv_effects.zip
		${WARP}/mediavp/mp-710_effects.rar )
	adveffects? (
		${WARP}/mvp368zeta/mv_adveffects.zip
		${WARP}/mediavp/mp-710_adveffects.rar )"

LICENSE="as-is"

RDEPEND="games-action/freespace2-data"
DEPEND="app-arch/unzip
	app-arch/unrar"

S=${WORKDIR}

pkg_setup() {
	if useq cell && useq adveffects ; then
		eerror "Error: 'cell' and 'adveffects' USE flags cannot both be enabled!"
		die
	fi
}

src_install() {
    insinto "${GAMES_PREFIX_OPT}/freespace2/mediavps"
    doins *.vp || die
    dodoc readme.txt || die
    prepgamesdirs
}
