# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A CLI-driven spreadsheet application; fork of SC"
HOMEPAGE="https://github.com/andmarti1424/sc-im"
SRC_URI="https://github.com/andmarti1424/sc-im/archive/v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	sys-libs/ncurses[unicode]
	dev-libs/libzip
	app-arch/bzip2"

RDEPEND="${DEPEND}"


S=${WORKDIR}/${P}/src

src_install() {
	emake prefix=/usr DESTDIR=${D} HELPDIR=/usr/share/doc/${P} install
#	dodir ${D}/usr/share/doc/${P}
	dodoc doc
}
