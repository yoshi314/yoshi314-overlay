# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit games

DESCRIPTION="MediaVPs for The Babylon Project"
KEYWORDS="~amd64 ~x86"
SLOT="0"

HOMEPAGE="http://babylon.hard-light.net/official_downloads.php"
SRC_URI="http://freespacemods.net/e107_files/downloads/2010-09-28-Zathras2.0.rar"

LICENSE="as-is"

RDEPEND="app-arch/unrar
	games-action/babylon-mediavps"

DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	# fdir=${S}/"The Babylon Project"
	# insinto "${GAMES_PREFIX_OPT}/babylon"
	# doins "${fdir}"/{*.vp,*.cfg,*.ogg} || die
	# insinto "${GAMES_PREFIX_OPT}/babylon/data"
	# doins -r "${fdir}"/data/{cache,missions,strips,tables} || die
	# doins "${fdir}"/data/*.cfg	 || die

	insinto "${GAMES_PREFIX_OPT}/babylon"
	fdir=${S}/"Zathras"
	doins "${fdir}"/{*.vp,*.bmp,*.ini} || die

	# if useq campaigns ; then
	# 	fdir=${S}/"tbp"
	# 	insinto "${GAMES_PREFIX_OPT}/babylon"
	# 	doins "${fdir}"/{*.vp,*.avi,*.ogg} || die
	# 	insinto "${GAMES_PREFIX_OPT}/babylon/data"
	# 	doins -r "${fdir}"/data/{missions,voice} || die
	# fi

	prepgamesdirs
}

