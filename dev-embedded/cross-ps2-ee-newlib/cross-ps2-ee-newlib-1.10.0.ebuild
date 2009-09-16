# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# ---------------------------------------------
# Initial script: ragnarok2040 at gmail dot com
# gentoo version: yoshi314 . gmail . com

EAPI=2

inherit eutils

DESCRIPTION="Newlib for Playstation2 development"

HOMEPAGE="http://ps2dev.org"

SRC_URI="ftp://sources.redhat.com/pub/newlib/newlib-${PV}.tar.gz"

LICENSE="GPL"

KEYWORDS="~x86 ~amd64"

DEPEND="sys-devel/make
sys-devel/patch
dev-embedded/cross-ps2-binutils
dev-embedded/cross-ps2-ee-gcc-base"

RDEPEND=""

_prefix=opt/ps2dev

S="${WORKDIR}"


src_unpack() {
  unpack ${A}
  # Set environment variables
  unset CFLAGS CXXFLAGS

  epatch ${FILESDIR}/newlib-${PV}-PS2.patch || die "newlib-${PV}-PS2.patch failed"

}

src_configure() {
    cd ${S}
    einfo "building newlib-${PV}"
    export PATH=$PATH:/$_prefix/ee/bin
    
    #something is screwed up - why do we need to change dirs?
    mkdir ee-newlib && cd ee-newlib
    ../newlib-${PV}/configure --prefix="/$_prefix/ee" --target="ee" || return 1

}
src_compile() {
	cd ${S}/ee-newlib
    make clean
    CC=ee-gcc CPPFLAGS="-G0" make || die "make failed"
    make -j1 DESTDIR=${D} install || die "installation failed"

}
