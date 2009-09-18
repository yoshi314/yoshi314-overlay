# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# ---------------------------------------------
# Initial script: ragnarok2040 at gmail dot com
# gentoo version: yoshi314 . gmail . com

#EAPI=2

inherit eutils

DESCRIPTION="C compiler for the Playstation2 Emotion Engine"
HOMEPAGE="http://ps2dev.org"
SRC_URI="http://ftp.gnu.org/gnu/gcc/gcc-${PV}.tar.bz2"
LICENSE="GPL"
KEYWORDS="~x86 ~amd64"

DEPEND="sys-devel/make
sys-devel/patch
dev-embedded/cross-ps2-binutils"

RDEPEND=""
_prefix=opt/ps2dev

S="${WORKDIR}/gcc-${PV}"


src_unpack() {
  unpack ${A}
  epatch ${FILESDIR}/gcc-${PV}-PS2.patch || die "gcc-${PV}-PS2.patch failed"
}

src_configure() {
    sleep 1
}

src_compile() {
    cd ${S}
    PATH=$PATH:/$_prefix/ee/bin
    einfo "building EE gcc"    
    CC=gcc-3.4.6 ./configure --prefix="/$_prefix/ee" --target="ee" --enable-languages="c" --with-newlib --without-headers || die "configure failed"
    make clean
    CC=gcc-3.4.6 make || die "make failed"
    CC=gcc-3.4.6 make -j1 DESTDIR=${D} install || die "installation failed"
    rm ${D}/$_prefix/ee/lib/libiberty.a
}

