# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Calibre is an ebook management software"
HOMEPAGE="https://calibre-ebook.com"



SRC_URI="x86? ( http://download.calibre-ebook.com/${PV}/calibre-${PV}-i686txz )
		amd64? ( http://download.calibre-ebook.com/${PV}/calibre-${PV}-x86_64.txz ) "

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=$WORKDIR

src_compile() {
	true
}

src_install() {
	#dodir ${D}/opt/calibre-${PV}

	insinto /opt/calibre-${PV}
	doins -r ${S}/lib
	doins -r ${S}/resources

	dodir /opt/calibre-${PV}/bin
	exeinto /opt/calibre-${PV}/bin
	doexe ${S}/bin/*

	exeinto /usr/bin
	doexe ${FILESDIR}/calibre-bin

	sed -i -e "s|@PATH@|/opt/calibre-${PV}|g" ${D}/usr/bin/calibre-bin
}
