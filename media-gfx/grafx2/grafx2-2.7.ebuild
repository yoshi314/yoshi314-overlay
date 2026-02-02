# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="A pixelart-oriented painting program"
HOMEPAGE="http://grafx2.chez.com/"
SRC_URI="https://gitlab.com/GrafX2/grafX2/-/archive/v${PV}/grafX2-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ttf lua sdl2"

DEPEND="media-libs/freetype
	media-libs/libpng
	ttf? ( media-libs/sdl-ttf )
	lua? ( >=dev-lang/lua-5.1.0 )
	sdl2? ( media-libs/libsdl2 
	media-libs/sdl2-image )
	!sdl2? ( media-libs/libsdl 
	media-libs/sdl-image )"

RDEPEND=""

src_prepare() {
	cd ${WORKDIR}/${PN}/src/
	sed -i s/lua5\.1/lua/g Makefile
}
src_compile() {
	use ttf || MYCNF="NOTTF=1"
	use lua || MYCNF="${MYCNF} NOLUA=1"
	use sdl2 && MYCNF="${MYCNF} API=sdl2"
	cd ${WORKDIR}/grafX2-v${PV}
	emake ${MYCNF} prefix=/usr || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/${PN}/src/
	emake DESTDIR="${D}" prefix="/usr" install || die "Install failed"
}

pkg_postinst() {
	elog "Please report bugs upstream:"
	elog "http://grafx2.chez.com/"
}
