# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

S="${WORKDIR}/mtpfs-${PV}.orig"

DESCRIPTION="A FUSE filesystem providing access to MTP devices."
HOMEPAGE="http://www.adebenham.com/mtpfs/"
SRC_URI="http://www.adebenham.com/mtpfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=sys-fs/fuse-2.2
	>=dev-libs/glib-2.6
	>=media-libs/libmtp-0.0.9"

RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS INSTALL NEWS README ChangeLog
}

pkg_postinst() {
	echo
	einfo "To mount your MTP device, issue:"
	einfo
	einfo "    /usr/bin/mtpfs <mountpoint>"
	einfo
	einfo "To unmount your MTP device, issue:"
	einfo
	einfo "    /usr/bin/fusermount -u <mountpoint>"

	if use debug ; then
		einfo
		einfo "You have enabled debugging output."
		einfo "Please make sure you run mtpfs with the -d flag."
	fi

	echo
}
