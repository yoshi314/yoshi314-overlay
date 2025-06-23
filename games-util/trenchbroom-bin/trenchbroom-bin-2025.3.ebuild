# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

DESCRIPTION="Trenchbroom is a quake level editor"
HOMEPAGE="https://kristianduske.com/trenchbroom/"
SRC_URI="https://github.com/TrenchBroom/TrenchBroom/releases/download/v${PV}/TrenchBroom-Linux-x64_64-v${PV}-Release.zip"

         https://github.com/TrenchBroom/TrenchBroom/releases/download/v2025.3/TrenchBroom-Linux-x86_64-v2025.3-Release.zip

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} media-libs/freeimage"
BDEPEND=""

inherit rpm

S=${WORKDIR}

src_compile() {
	true
}

src_install() {
	cd $WORKDIR
	doins -r usr
	insinto /usr/share/applications
	doins usr/share/TrenchBroom/trenchbroom.desktop
	exeinto /usr/bin
	doexe usr/bin/trenchbroom
}
