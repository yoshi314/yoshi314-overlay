# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Exitx is a tool to provide shutdown/reboot dialog"

HOMEPAGE="http://github.com/z0id/exitx-polkit"
#SRC_URI=""
EGIT_REPO_URI="git://github.com/z0id/exitx-polkit.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2
	x11-libs/libX11"

RDEPEND="${DEPEND}"

inherit git-2

src_install() {
	dobin exitx
	dodoc README
}
