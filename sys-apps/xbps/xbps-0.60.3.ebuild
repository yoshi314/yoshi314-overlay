# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

DESCRIPTION="XBPS is a package manager for Void Linux"
HOMEPAGE="http://www.voidlinux.org"
SRC_URI="https://github.com/void-linux/xbps/archive/${PV}.tar.gz"

inherit autotools


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="api-docs static-utils"

DEPEND="api-docs? ( app-doc/doxygen ) 
		app-arch/libarchive"


RDEPEND="${DEPEND}"

BUILD_DIR="${WORKDIR}/${P}"

src_configure() {
	local myeconfargs=(
		$(use_enable api-docs)
		$(use_enable static-utils static)
	)


}

#src_compile() {
#	autotools-utils_src_compile
#}
#
#src_install() {
#	autotools-utils_src_install
#}
