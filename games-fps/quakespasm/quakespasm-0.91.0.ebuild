# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="A *nix firendly FitzQuake with new features"
HOMEPAGE="http://quakespasm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall debug demo mp3 ogg sdl-net sdl2"

DEPEND="virtual/opengl
	mp3? ( || ( media-libs/libmad media-sound/mpg123 ) )
	ogg? ( media-libs/libvorbis )
	sdl-net? (  media-libs/sdl-net ) 
	sdl2? ( media-libs/libsdl2 )"

RDEPEND="${DEPEND}
	cdinstall? ( games-fps/quake1-data )
	demo? ( games-fps/quake1-demodata )"

S=${WORKDIR}/${P}/Quake

src_prepare() {
#	epatch "${FILESDIR}/${PV}"-makefile.patch
# do sed instead

sed -i \
    -e '/USE_CODEC_MP3/s/1/0/g' \
    -e '/USE_CODEC_VORBIS/s/1/0/g' \
    -e '/USE_CODEC_WAVE/s/1/0/g' \
    -e '/^STRIP/s/strip/echo/g' \
    Makefile

# most of this patch is provided in 0.90.0
# except for one entry for USE_PASSWORD_FILE
#	epatch "${FILESDIR}"/homedir_0.patch

	sed -i -e \
		"s!parms.basedir = \".\"!parms.basedir = \"${GAMES_DATADIR}/quake1\"!" \
		main_sdl.c || die "sed failed"
}

src_compile() {
	local opts=""
	use debug && opts="DEBUG=1"
	use mp3 && opts="${opts} USE_CODEC_MP3=1"
	use ogg && opts="${opts} USE_CODEC_VORBIS=1"
	use sdl-net && opts="${opts} SDLNET=1"
	use sdl2 && opts="${opts} SDL2=1"

	emake ${opts} || die "emake failed"
}

src_install() {
	dogamesbin "${PN}" || die "dogamesbin failed"

	prepgamesdirs
}
