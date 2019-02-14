# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Archlinux Helper Installation Scripts"

HOMEPAGE="https://projects.archlinux.org/arch-install-scripts.git/"

EGIT_REPO_URI="git://projects.archlinux.org/arch-install-scripts.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/pacman"

inherit git-2

src_compile() {
	emake  || die "Fail"
}

src_install()	{
	make install DESTDIR=${D} PREFIX=/usr || die "Fail"
}

pkg_postinst() {
	einfo "Package consists of following scripts : "
	einfo "pacstrap - allows to bootstrap an archlinux installation"
	einfo " ( requires pacman and its gpg keyring ) "
	einfo "arch-chroot chroots into specified dir along with mounting important dirs"
	einfo " ( e.g. dev, proc, sys, run )"
	einfo "genfstab will print out essential fstab entries for a system image"
	einfo " located under specified directory"
	einfo "Naturally, the latter two can be used with non-archlinux"
	einfo " installations as well"
}
