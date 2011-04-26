# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="List of mirrors for pacman"

HOMEPAGE="http://archlinux.org/pacman"

#SRC_URI="http://repos.archlinux.org/viewvc.cgi/pacman-mirrorlist/trunk/mirrorlist?view=co"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"

DEPEND=""

RDEPEND=""

S=${WORKDIR}/${P}

src_install() {
	wget http://www.archlinux.org/mirrorlist/i686/all/ -O mirrorlist
	insinto /etc/pacman.d
	doins mirrorlist 
}

