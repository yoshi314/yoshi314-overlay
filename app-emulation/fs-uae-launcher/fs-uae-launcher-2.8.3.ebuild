# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4,3_5,3_6,3_7} )
PYTHON_REQ_USE="sqlite"

inherit eutils distutils-r1

MY_PV="${PV/_}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="PyQt launcher for FS-UAE"
HOMEPAGE="http://fs-uae.net/"
SRC_URI="http://fs-uae.net/fs-uae/stable/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/pyside[${PYTHON_USEDEP}] )
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/python-lhafile[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Remove bundled six bug #546730
	sed -i '/"six": "."/d' setup.py || die "sed failure"
}

src_compile() {
	distutils-r1_src_compile
	emake mo
}

python_install() {
	cd "${S}" || die
	distutils-r1_python_install --install-lib="${ROOT}usr/share/${PN}"
	emake prefix="${ROOT}usr" DESTDIR="${D}" install
}
