# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

DESCRIPTION="The Babylon Project meta package. TBP is stand-alone and does not need original Freespace 2 to work."
HOMEPAGE="http://scp.indiegames.us/"

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="yal"

RDEPEND="games-action/fs2_open[babylon]
	yal? ( games-action/fs2_launcher )
	games-action/babylon-mediavps
	games-action/babylon-zathras"
