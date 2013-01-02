# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Dex is a tool to manage and launch autostart entries."

HOMEPAGE="http://e-jc.de/"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/jceb/dex.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/python-3.0.0
		virtual/python-argparse"
RDEPEND="${DEPEND}"


inherit git-2


src_install() {
	dobin dex
	dodoc README
}
