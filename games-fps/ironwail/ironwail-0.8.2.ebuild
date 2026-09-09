# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2


# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A high-performance fork of the QuakeSpasm source port"
HOMEPAGE="https://github.com/andrei-drexler/ironwail"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com"
else
	SRC_URI="https://github.com/andrei-drexler/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/libogg
	media-libs/libvorbis
	virtual/opengl
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/Quake"

src_compile() {
	emake \
		CC="$(tc-getCC)"
}

src_install() {
	find ${D}
	dobin ironwail
	insinto /usr/share/${P}
	doins ${WORKDIR}/${PN}-${PV}/Quake/ironwail.pak
	einstalldocs
}

pkg_postinst() {
	einfo "Quakespasm comes with a (optional) supplementary pak file that you should place in your id1 directory"
	einfo "It's located in /usr/share/${P}/ironwail.pak"
}
