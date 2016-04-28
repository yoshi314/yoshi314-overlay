# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-app

MY_P="${P}-fixed"
DESCRIPTION="control the sound volume easily through a tray icon"
HOMEPAGE="http://oliwer.net/b/volwheel.html"
SRC_URI="http://olwtools.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

RDEPEND="dev-lang/perl
dev-perl/gtk2-perl
dev-perl/gtk2-trayicon
alsa? ( media-sound/alsa-utils )"

S="${WORKDIR}/${MY_P}"

src_install() {
dobin volwheel || die

insinto /usr/share/${PN}
doins -r icons || die

perlinfo
insinto ${VENDOR_LIB}
doins lib/*.pm || die

dodoc ChangeLog README TODO || die
}
