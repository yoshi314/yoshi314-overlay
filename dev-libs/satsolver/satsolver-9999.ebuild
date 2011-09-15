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
IUSE="doc ruby-bindings python-bindings perl-bindings"

DEPEND="dev-libs/check
	doc? ( app-doc/doxygen )
	python-bindings? ( dev-lang/python dev-lang/swig )
	ruby-bindings? ( dev-lang/ruby )
	perl-bindings? ( dev-lang/perl )
	sys-libs/zlib
	dev-libs/expat"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "$FILESDIR"/documentation.patch
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc DOCUMENTATION)
		$(cmake-utils_use_enable python-bindings PYTHON)
		$(cmake-utils_use_enable ruby-bindings RUBY)
		$(cmake-utils_use_enable perl-bindings PERL)
		#this fixes rpm includes
		-DFEDORA=1
	)
}
