# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="A text completion system for ibus input framework, with dictionary and learning support"
HOMEPAGE="https://mike-fabian.github.io/ibus-typing-booster"
SRC_URI="https://github.com/mike-fabian/ibus-typing-booster/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.3.99.20110817
	dev-libs/m17n-lib
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.16.1"

RDEPEND="${RDEPEND}"

src_configure() {
	local myconf

	econf \
		$(use_enable nls) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README || die
}

