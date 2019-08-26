# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

DESCRIPTION="Trenchbroom is a quake level editor"
HOMEPAGE="https://kristianduske.com/trenchbroom/"
SRC_URI="https://github.com/kduske/TrenchBroom/releases/download/v${PV}/TrenchBroom-Linux-v${PV}-Release.x86_64.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} media-libs/freeimage"
BDEPEND=""

inherit rpm

S=${WORKDIR}

src_unpack() {
	rpm_unpack TrenchBroom-Linux-v${PV}-Release.x86_64.rpm
}

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
