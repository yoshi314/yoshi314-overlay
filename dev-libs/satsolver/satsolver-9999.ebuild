# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="Library for resolution solving"
HOMEPAGE="https://gitorious.org/opensuse/sat-solver"
EGIT_REPO_URI="git://gitorious.org/opensuse/sat-solver.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="dev-libs/check
doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "$FILESDIR"/documentation.patch
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc DOCUMENTATION)
		#this fixes rpm includes
		-DFEDORA=1
	)
}
