# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="Zypper - openSUSE package manager"
HOMEPAGE="https://gitorious.org/opensuse/zypper"
EGIT_REPO_URI="git://github.com/openSUSE/zypper.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-admin/augeas
	dev-libs/libzypp
	sys-libs/readline
	sys-devel/gettext"

RDEPEND="${DEPEND}"

#CMAKE_BUILD_DIR="${WORKDIR}/${P}"

#src_prepare() {
#	epatch "$FILESDIR"/documentation.patch
	#warnings as errors makes it fail. disable that option 
#	sed -i -e 's/-Werror//g' CMakeLists.txt
#}

#src_configure() {
#	mycmakeargs=(
#		#this fixes rpm includes
#		-DFEDORA=1
#	)
#	cmake-utils_src_configure
#}
