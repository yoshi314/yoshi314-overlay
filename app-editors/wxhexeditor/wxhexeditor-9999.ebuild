# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI=5
inherit autotools wxwidgets subversion eutils

ESVN_REPO_URI="https://wxhexeditor.svn.sourceforge.net/svnroot/wxhexeditor/trunk"

WX_GTK_VER="2.8"

DESCRIPTION="wxGTK hexadecimal editor"
HOMEPAGE="http://wxhexeditor.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=x11-libs/wxGTK-${WX_GTK_VER}*"
DEPEND="${RDEPEND}"

src_compile() {
    make || die "emake failed"
}

src_install() {
    make DESTDIR="${D}" install || die "make install failed "
}
