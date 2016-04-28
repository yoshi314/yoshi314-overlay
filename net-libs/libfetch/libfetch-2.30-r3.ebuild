# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="URL-based download library"
HOMEPAGE=""
SRC_URI="ftp://ftp.archlinux.org/other/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}


src_compile() {
	cp ${FILESDIR}/Makefile ${S}
	emake || die "Compilation failed"
	make install DESTDIR=${D} || die "Installation failed"
}


