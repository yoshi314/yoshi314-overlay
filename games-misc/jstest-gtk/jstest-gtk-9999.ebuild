# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="GTK based joystick test app"

HOMEPAGE="http://pingus.seul.org/~grumbel/jstest-gtk/"

EGIT_REPO_URI="https://github.com/Grumbel/jstest-gtk.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/scons
    dev-libs/libsigc++:2
    dev-cpp/gtkmm:2.4
    dev-libs/expat"

RDEPEND="${DEPEND}"

inherit git-2 scons-utils eutils

src_prepare() {
    epatch  ${FILESDIR}/datadir.patch
}

src_compile() {
	escons
}

src_install() {
    dobin jstest-gtk
    dodoc COPYING NEWS README.md
    insinto /usr/share/jstest-gtk
    doins data/*.{png,xml}
    doman data/jstest-gtk.1
}

