# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="Backend library for zypper package manager"
HOMEPAGE="https://github.com/openSUSE/libzypp"
EGIT_REPO_URI="git://github.com/openSUSE/libzypp.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc libproxy"

DEPEND="app-arch/rpm
	doc? ( app-doc/doxygen )
	libproxy? ( net-libs/libproxy )
	sys-libs/zlib
	dev-libs/expat
	dev-libs/boost
	sys-devel/gettext
	net-misc/curl
	dev-libs/libxml2
	dev-libs/satsolver
	dev-libs/openssl"

RDEPEND="${DEPEND}"

CMAKE_BUILD_DIR="${WORKDIR}/${P}"

src_prepare() {
	epatch "$FILESDIR"/cmakelists-libproxy-documentation.patch
	#warnings as errors makes it fail. disable that option 
	sed -i -e 's/-Werror//g' CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable doc DOCUMENTATION)
		$(cmake-utils_use_with libproxy LIBPROXY)
		#this fixes rpm includes
#		-DFEDORA=1
	)
	cmake-utils_src_configure
}
