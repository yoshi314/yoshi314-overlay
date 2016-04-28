# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Clic-FS ; fuse based filesystem used widely in openSUSE"
HOMEPAGE="https://gitorious.org/opensuse/clicfs"
#SRC_URI=""

EGIT_REPO_URI="git://gitorious.org/opensuse/clicfs.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-fs/fuse
		app-arch/xz-utils
		dev-libs/openssl"

RDEPEND="${DEPEND}"

inherit cmake-utils git

src_prepare() {
	#subdirectory misc doesn not build. ext2 structure mismatches.
	sed -i -e 's/ADD_SUBDIRECTORY(misc)//g' CMakeLists.txt
}
