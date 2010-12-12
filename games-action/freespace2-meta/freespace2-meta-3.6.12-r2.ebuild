# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

# inherit games eutils

DESCRIPTION="The Freespace2 Open Project meta package."
HOMEPAGE="http://scp.indiegames.us/"

LICENSE="fs2_open"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="yal"

RDEPEND="games-action/fs2_open[freespace2]
	games-action/freespace2-data
	games-action/freespace2-mediavps
	yal? ( games-action/fs2_launcher )"
