# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="URL based download library, forked from libfetch"
HOMEPAGE="http://phraktured.net/libdownload"
SRC_URI="http://code.phraktured.net/?p=libdownload.git;a=blob;f=dist/${P}.tar.gz"
#SRC_URI="http://phraktured.net/libdownload/dist/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="virtual/libc"
RDEPEND="${DEPEND}"
#S="${WORKDIR}/${P}"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

