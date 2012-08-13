# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Archlinux Helper Installation Scripts"
HOMEPAGE="https://github.com/falconindy/arch-install-scripts"
#SRC_URI=""

EGIT_REPO_URI="git://github.com/falconindy/arch-install-scripts.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/pacman"
RDEPEND="${DEPEND}"

inherit git-2

src_compile() {
	emake  || die "Fail"
}

src_install()	{
	make install DESTDIR=${D} PREFIX=/usr || die "Fail"
}
