# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# ---------------------------------------------
# Initial script: ragnarok2040 at gmail dot com
# gentoo version: yoshi314 . gmail . com

EAPI=2

inherit eutils

DESCRIPTION="Binutils for Playstation2 development"

HOMEPAGE="http://ps2dev.org"

SRC_URI="http://ftp.gnu.org/gnu/binutils/binutils-${PV}.tar.gz"

LICENSE="GPL"

KEYWORDS="~x86 ~amd64"

DEPEND="sys-devel/make
sys-devel/patch"

RDEPEND=""

_prefix=opt/ps2dev

S="${WORKDIR}/binutils-${PV}"


src_unpack() {
  unpack ${A}
  # Set environment variables
  unset CFLAGS CXXFLAGS

  epatch ${FILESDIR}/binutils-${PV}-PS2.patch || die "binutils-${PV}.patch failed"
  epatch ${FILESDIR}/binutils-destdir.patch || die "binutils-destdir-patch failed"

}

src_configure() {
	sleep 1
}

src_compile() {
	cd ${S}
    for _target in "ee" "iop" "dvp"; do
    einfo "Building binutils for $TARGET..."

    ./configure --prefix="/$_prefix/$_target" --target="$_target" || return 1

    make clean
    make || die "make failed"
    make -j1 DESTDIR=${D} install || die "installation failed at target	${_target}"
  done
}

