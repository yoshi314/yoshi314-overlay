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

inherit git-2

src_compile() {
	sed -i -e 's|data/generic.png|/usr/share/jstest-gtk/generic.png|' src/joystick_list_widget.cpp
	scons  || die "Fail"
}

src_install()	{

dobin jstest-gtk
dodoc COPYING NEWS README
insinto /usr/share/jstest-gtk
doins data/*.{png,xml}
doman data/jstest-gtk.1
}

