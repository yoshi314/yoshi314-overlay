# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

# Might be able to download from here in the future
Q="http://www.quaddicted.com/filebase"
MY_PN="nehahra"

DESCRIPTION="Classic story-driven mission & movie pack for Quake 1"
HOMEPAGE="http://nehahra.planetquake.gamespy.com/"
SRC_URI="movie? ( The_Seal_Of_Nehahra.zip )
	nehahra1.zip
	nehahra2.zip
	nehahra3.zip
	elek_neh_episode4.zip
	nehupdate3.zip
	nehmusicfix.zip"

# See disclaimers section in nehahra.txt
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="movie X"
RESTRICT="fetch strip"

# Only darkplaces can run it stably
RDEPEND="X? ( games-fps/darkplaces )"
DEPEND="app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_DATADIR}/quake1

pkg_nofetch() {
	einfo "Please download the following files:"
	einfo "${A}"
	einfo "from ${HOMEPAGE}"
	einfo "and move them to ${DISTDIR}"
}

src_unpack() {
	# Unpack in correct order
	unpack ${A}

	mv Quake/${MY_PN}/maps QUAKE/${MY_PN}
	mv Quake/${MY_PN}/mods/* QUAKE/${MY_PN}/mods
	rm -rf Quake

	# Fix filenames
	local d f fname lcfname
	for f in $(find . -type f) ; do
		fname=$(basename "${f}")
		lcfname=$(echo "${fname}" | tr [:upper:] [:lower:])
		if [[ "${lcfname}" != "${fname}" ]] ; then
			# Rename the file to lower-case
			d=$(dirname "${f}")
			mv "${f}" "${d}/${lcfname}"
		fi
	done

	rm QUAKE/*.{dll,exe}
	if use movie ; then
		# Has a 30mb pak0.pak file
		rm neh-readme.txt

		# Fix directory names
		mv QUAKE/${MY_PN}/SOUND/WALL QUAKE/${MY_PN}/SOUND/wall
		mv QUAKE/${MY_PN}/SOUND QUAKE/${MY_PN}/sound
	else
		# Use dummy pak0.pak file
		unpack ./QUAKE/nehahra/pak0.zip
	fi

	rm QUAKE/${MY_PN}/pak0.zip
	mv QUAKE/${MY_PN}/*.html .
	find . -name '*.txt' -exec mv '{}' . \;
	rm {important*,nehexe,help}.txt
}

src_install() {
	insinto "${dir}"
	doins -r QUAKE/${MY_PN} || die "doins -r failed"

	dodoc *.txt
	dohtml *.html

	prepgamesdirs
}


