# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="GTK client for remote management of the Transmission BitTorrent client, using its HTTP RPC protocol"
HOMEPAGE="http://code.google.com/p/transmission-remote-gtk"
LICENSE="GPL-2"
SLOT="0"
LANGS=" de ko pl ru"
IUSE="geoip debug ${LANGS// / linguas_}"
DOCS="AUTHORS README"

if [ ${PV} != "9999" ]; then
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
KEYWORDS="~x86 ~amd64"
else
inherit subversion autotools
ESVN_REPO_URI="http://transmission-remote-gtk.googlecode.com/svn/trunk"
SRC_URI=""
KEYWORDS=""
fi

DEPEND="geoip? ( dev-libs/geoip )
gnome-base/gconf
dev-libs/libunique
x11-libs/libnotify
net-libs/libproxy
>=dev-libs/json-glib-0.12.2
>=x11-libs/gtk+-2.16
>=net-misc/curl-7.0
>=dev-libs/glib-2.22"

RDEPEND="${DEPEND}"

src_configure() {
[ ${PV} = "9999" ] && eautoreconf
econf \
$(use_enable debug) \
$(use_with geoip libgeoip)
}

src_install() {
gnome2_src_install
}
