# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator xdg-utils

DESCRIPTION="Anki is a flashcard learning app"
HOMEPAGE="https://apps.ankiweb.net"
# https://apps.ankiweb.net/downloads/current/anki-2.1.4-linux-amd64.tar.bz2

MY_VER=$(get_version_component_range 1-3 $PV)


SRC_URI="https://apps.ankiweb.net/downloads/current/anki-${MY_VER}-linux-amd64.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="!app-misc/anki !app-misc/anki-beta-bin"


S="${WORKDIR}/anki-${MY_VER}-linux-amd64"

src_unpack() { 

	default
	cd $S
	sed -i -e '/xdg-mime/d' Makefile
	sed -i -e '/@echo/d' Makefile
#2.1.17 broken Makefile
#	sed -i -e "/.*xdg-mime/\txdg-mime" Makefile
#	sed -i -e "/.*@echo/\t@echo" Makefile
}
src_compile() {
	true
}

src_install() { 
	emake install PREFIX=${D}/usr
}

pkg_postinst() {
	xdg-mime install /usr/share/anki/anki.xml --novendor
	xdg-mime default anki.desktop application/x-anki
	xdg-mime default anki.desktop application/x-apkg
	xdg_desktop_database_update
}

pkg_prerm() { 
	xdg-mime uninstall /usr/share/anki/anki.xml
}
