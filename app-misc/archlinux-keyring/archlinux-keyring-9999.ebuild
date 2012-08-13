# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Archlinx GPG Keys"
HOMEPAGE="http://archlinux.org"
#SRC_URI=""
EGIT_REPO_URI="git://projects.archlinux.org/archlinux-keyring.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/pacman"
RDEPEND="${DEPEND}"

inherit git-2

#src_prepare() {
#	sed -i -e '/^PREFIX/s/\/local//g' Makefile
#}


#not specifying dummy src_compile will do the install phase to /usr/local
src_compile() {
	true
}

src_install() {
	make DESTDIR=${D} PREFIX=/usr install
}

pkg_postinst() {
	einfo "In order to use archlinux keyring with pacman,"
	einfo "you will need to run	the following commands: "
	einfo "pacman-key --init"
	einfo "pacman-key --populate archlinux"
	einfo "If you encounter problems, remove /etc/pacman.d/gnupg directory"
	einfo "And try the commands again"
}
