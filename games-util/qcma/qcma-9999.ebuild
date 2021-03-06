# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2-utils

DESCRIPTION="QCMA is a Playstation Vita backup assistant"
HOMEPAGE="https://github.com/codestation/qcma"
#SRC_URI=""

EGIT_REPO_URI="https://github.com/codestation/qcma"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-qt/qtsql:5"
RDEPEND="${DEPEND}"

src_configure() { 
	qmake qcma.pro PREFIX=${D}/usr
	lrelease common/resources/translations/qcma_*.ts
	emake INSTALL_ROOT=${D}
	make install
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
