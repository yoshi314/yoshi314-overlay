# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"

inherit eutils qt4

DESCRIPTION="Qt4 Crossplatform Jabber client."
HOMEPAGE="http://code.google.com/p/vacuum-im"
SRC_URI="http://vacuum-im.googlecode.com/files/${P}-source.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PLUGINS="+adiummessagestyle +annotations +autostatus +avatars +bitsofbinary +bookmarks +captchaforms +chatstates +clientinfo +commands +compress +console +dataforms +datastreamsmanager +emoticons +filestreamsmanager +filetransfer +gateways +inbandstreams +iqauth +jabbersearch +messagearchiver +multiuserchat +privacylists +privatestorage +registration +servicediscovery +sessionnegotiation +skinmanager +socksstreams +vcard +xmppuriqueries"
IUSE="${PLUGINS}"

DEPEND=">=x11-libs/qt-core-4.5:4[ssl]
	>=x11-libs/qt-gui-4.5:4
	>=dev-libs/openssl-0.9.8k
	adiummessagestyle? ( >=x11-libs/qt-webkit-4.5:4 )"
RDEPEND="${DEPEND}"
PDEPEND=""

v_use_needs() {
	for dep in ${@:2}
	do
		use $1 && use !$dep && ewarn "USE=$1 requires $dep, $1 will be disabled."
	done
}

pkg_setup() {
	# from revision 931
	v_use_needs captchaforms dataforms
	v_use_needs commands dataforms
	v_use_needs datastreamsmanager dataforms
	v_use_needs registration dataforms
	v_use_needs sessionnegotiation dataforms
}

src_prepare() {
	# we want system zlib
	rm -r src/thirdparty/zlib
	sed -i -e 's/zlib //' \
		src/thirdparty/thirdparty.pro
	sed -i -e 's/..\/zlib\/zlib.h/zlib.h/' \
		src/thirdparty/minizip/zip.h \
		src/thirdparty/minizip/unzip.h
	sed -i -e 's/..\/..\/thirdparty\/zlib\/zlib.h/zlib.h/' \
		src/plugins/compress/compression.h
	sed -i -e 's/-lzlib/-lz/' \
		src/utils/utils.pro \
		src/plugins/compress/compress.pro
}

src_configure() {
	for plugin in ${PLUGINS//+/}
	do
		if ! use ${plugin}; then
			rm -rf {resources,src/plugins,translations/*}/${plugin}{,s}{,.qm}
			sed -e "s/${plugin}//" -i src/plugins/plugins.pro
		fi
	done
}

src_compile() {
	eqmake4 vacuum.pro \
		INSTALL_PREFIX="/usr" \
		INSTALL_APP_DIR="${PN}" \
		INSTALL_LIB_DIR="$(get_libdir)" \
		INSTALL_RES_DIR="share"\
		|| die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
