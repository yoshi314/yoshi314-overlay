EAPI=8

DESCRIPTION="A RAW editor with various AI integrations"
HOMEPAGE="https://github.com/CyberTimon/RapidRAW"
SRC_URI="https://github.com/CyberTimon/RapidRAW/releases/download/v${PV}/03_RapidRAW_v${PV}_ubuntu-24.04_amd64.deb -> ${P}.deb
tethering? ( https://github.com/CyberTimon/RapidRAW/releases/download/v${PV}/03_tethering_RapidRAW_v${PV}_ubuntu-24.04_amd64.deb -> ${P}-tethering.deb )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="tethering"

RDEPEND="net-libs/webkit-gtk:4.1
tethering? ( media-libs/libgphoto2 ) "

inherit unpacker

S=${WORKDIR}

src_unpack() {
	cd $WORKDIR
	unpack_deb ${P}.deb
}
src_compile() {
	elog "compile"
}

src_install() {
#	cd ${WORKDIR}
	dobin usr/bin/RapidRAW
	insinto ${DESTDIR}/usr/lib
	doins -r usr/lib/RapidRAW
	insinto ${DESTDIR}/usr/share
	doins -r usr/share/icons
	doins -r usr/share/applications
}

pkg_postinst() {
	xdg_icon_cache_update
	elog "Please report bugs upstream:"
	elog "https://github.com/CyberTimon/RapidRAW"
}

pkg_postrm() {
	xdg_icon_cache_update
}
