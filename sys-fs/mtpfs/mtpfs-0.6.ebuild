# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/zfs-fuse/zfs-fuse-0.4.0_beta1.ebuild,v 1.1 2007/06/25 15:24:17 trapni Exp $

inherit eutils

DESCRIPTION="An MTP (Multimedia Transport Protocol) filesystem for FUSE/Linux"
HOMEPAGE="http://www.adebenham.com/mtpfs/"
SRC_URI="http://www.adebenham.com/mtpfs/mtpfs-${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-libs/glibc-2.3.3
	>=media-libs/libmtp-0.0.9
	>=dev-libs/glib-2.6
	>=sys-fs/fuse-2.2"

RDEPEND=">=sys-fs/fuse-2.6.1"

src_unpack() {
	unpack ${A}
}

src_install() {
	make DESTDIR=${D} install || die "Error installing"
	dodoc AUTHORS
	dodoc COPYING
	dodoc ChangeLog
	dodoc INSTALL
	dodoc NEWS
	dodoc README
}

pkg_postinst() {
	echo
	einfo "To mount your MTP device run"
	einfo
	einfo "		/usr/bin/mtpfs <mountpoint>"
	einfo
	einfo "To umount your MTP device run"
	einfo
	einfo "		/usr/bin/fusermount -u <mountpoint>"
	echo
}
