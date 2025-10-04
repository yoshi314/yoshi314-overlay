# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://github.com/nkanaev/yarr.git"

DESCRIPTION="Yet Another RSS Reader"
HOMEPAGE="https://github.com/nkanaev/yarr"
TEGIT_REPO_URI="https://github.com/nkanaev/yarr.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.23.0
|| ( sys-devel/gcc llvm-core/clang )
"

RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	make host
}

src_install() {
	dobin out/yarr
	dodoc doc/*
}
