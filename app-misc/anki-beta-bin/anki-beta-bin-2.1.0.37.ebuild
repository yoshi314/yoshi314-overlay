# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

DESCRIPTION="Anki is a flashcard learning app"
HOMEPAGE="https://apps.ankiweb.net"
# https://apps.ankiweb.net/downloads/beta/anki-2.1.0beta27-amd64.tar.bz2

MY_VER=$(get_version_component_range 1-3 $PV)
MY_BETA_REV=$(get_version_component_range 4 $PV)


SRC_URI="https://apps.ankiweb.net/downloads/beta/anki-${MY_VER}beta${MY_BETA_REV}-amd64.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="!app-misc/anki"


S="${WORKDIR}/anki-${MY_VER}beta${MY_BETA_REV}-amd64"

src_unpack() { 

	default
	cd $S
	sed -i -e '/xdg-mime/d' Makefile
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
	xdg-mime uninstall ${PREFIX}/share/anki/anki.xml
	xdg_desktop_database_update
}
