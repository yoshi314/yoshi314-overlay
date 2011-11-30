# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5"

EGIT_REPO_URI="git://git.tensixtyone.com/code/oblogout.git"

inherit eutils python git

DESCRIPTION="Openbox logout script"
HOMEPAGE="https://code.launchpad.net/oblogout"
#SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk
    dev-python/imaging"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_compile() {
	python setup.py build || die "failed to build"
}

src_install() {
	python setup.py install --root="${D}" || die "failed to build"
}

