# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5"

EGIT_REPO_URI="git://github.com/nsf/obkey.git"

inherit distutils eutils python git

DESCRIPTION="Openbox key shortcut configuration tool"
HOMEPAGE="https://code.google.com/p/obkey/"
#SRC_URI=""

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	python_copy_sources
}


src_install() {
	python_src_install
	python_clean_installation_image
}

pkg_postinst() {
	python_mod_optimize gtk-2.0
}

pkg_postrm() {
	python_mod_cleanup gtk-2.0
}
