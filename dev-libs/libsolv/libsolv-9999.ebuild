# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils git

EAPI=3

DESCRIPTION="A dependency solving library for openSUSE"
HOMEPAGE="https://github.com/openSUSE/libsolv"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/openSUSE/libsolv.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static perl python ruby"

DEPEND="dev-libs/expat
	sys-libs/zlib
	perl? ( dev-lang/perl )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	app-arch/rpm"

RDEPEND="${DEPEND}"


src_prepare() {
	#warnings make build fail
	#this disables that setting
	sed -i -e 's/-Werror//g' CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable static STATIC)
		$(cmake-utils_use_enable python PYTHON)
		$(cmake-utils_use_enable ruby RUBY)
		-DFEDORA=1  #required for proper db.h inclusion

	)
	cmake-utils_src_configure
}
