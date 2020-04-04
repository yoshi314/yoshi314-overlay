# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GZDoom's music library"
HOMEPAGE="https://github.com/coelckers/ZMusic"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/coelckers/ZMusic"


inherit git-r3 cmake-multilib

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""


PATCHES=(
	"${FILESDIR}/cmake_install.patch"
)

src_configure() {
	cmake-multilib_src_configure -DLIB_INSTALL_PATH=${get_libdir}
}


