# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion eutils
DESCRIPTION="GTK GUI for Transmission. Can be used to manage transmission on
remote machines"
HOMEPAGE="https://code.google.com/p/transmission-remote-gtk/"
#SRC_URI=""
ESVN_REPO_URI="http://transmission-remote-gtk.googlecode.com/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="geoip"

DEPEND="geoip? ( dev-libs/geoip ) 
		x11-libs/gtk+:2"

RDEPEND="${DEPEND}"

src_configure() {
	./autogen.sh
	econf "$(use_with geoip libgeoip)"
}
src_install() {
	einstall
}
