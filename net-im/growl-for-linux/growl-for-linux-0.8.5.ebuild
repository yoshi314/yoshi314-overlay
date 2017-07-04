# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit multilib

DESCRIPTION="Growl Implementation For Linux"
SRC_URI="https://github.com/mattn/growl-for-linux/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-db/sqlite:3
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl
	net-misc/curl
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${ED}/usr/$(get_libdir)/growl-for-linux" -name "*.la" -exec rm {} + || die

	dodoc AUTHORS ChangeLog README* TODO || die
}
