# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Pacman - Archlinux Package Manager"

HOMEPAGE="http://archlinux.org/pacman"

SRC_URI="ftp://ftp.archlinux.org/other/pacman/${P}.tar.gz"
#SRC_URI="http://www.archlinux.org/~dan/pacman/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="debug doxygen"


RDEPEND="app-arch/libarchive
		net-libs/curl
		fakeroot? ( sys-apps/fakeroot )
		doxygen? ( app-doc/doxygen )"

DEPEND="${RDEPEND}"


# A space delimited list of portage features to restrict. man 5 ebuild
# for details. Usually not needed.
#RESTRICT="strip"


RDEPEND=""

S=${WORKDIR}/${P}

src_compile() {
	econf $(use_enable doxygen) $(use_enable debug) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

