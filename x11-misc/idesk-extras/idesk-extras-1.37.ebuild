# ebuild by Ryan Dagey, ryan@neoterichovercraft.com
# 22-Apr-2005
# Based on idesk-extras, http://users.netwit.net.au/~pursang/idesk-extras.html, pursang@netwit.net.au
# $Header: 

inherit eutils

DESCRIPTION="Set of idesk icons and interface"
HOMEPAGE="http://users.netwit.net.au/~pursang/idesk-extras.html"
SRC_URI="http://www.jmurray.id.au/idesk-extras-${PV}.tgz"

LICENSE="freely distributed"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~amd64"
IUSE=""

DEPEND="x11-misc/idesk
	x11-misc/xdialog"

#tarball weirdness. don't blame me.
S="${WORKDIR}/home/john/tmp"

src_install() {
	dobin ${S}/${P}/idesktool 
	dohtml ${S}/${P}/ideskextras.html
	dodir /usr/share/idesk
#standard way does not work :/
	insinto /usr/share/idesk/icons/32x32
	doins ${S}/${P}/icons/32x32/*
	insinto /usr/share/idesk/icons/48x48
	doins ${S}/${P}/icons/48x48/*
}

src_postinst() {
    einfo
    einfo "NOTE: Please refer to ${HOMEPAGE}"
    einfo "NOTE: For info on configuring ${PN}"
    einfo
}
