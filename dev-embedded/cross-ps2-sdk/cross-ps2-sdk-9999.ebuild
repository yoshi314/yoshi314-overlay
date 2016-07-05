# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils 

EAPI="2"

DESCRIPTION="Playstation2 Homebrew SDK"
HOMEPAGE="http://ps2dev.org/"
SRC_URI=""

LICENSE="AFL-2"
KEYWORDS="~amd64 ~x86"

IUSE="source doc"

DEPEND="dev-embedded/cross-ps2-binutils  
dev-embedded/cross-ps2-ee-newlib  
dev-embedded/cross-ps2-ee-gcc  
dev-embedded/cross-ps2-iop-gcc
doc? ( app-doc/doxygen )"

RDEPEND=""

ESVN_REPO_URI="svn://svn.ps2dev.org/ps2/trunk/ps2sdk"

_prefix="/opt/ps2dev"
_svnmod="ps2sdk"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	export PS2SDK=${D}/opt/ps2dev/$_svnmod
	export PS2DEV=$_prefix
	export PS2SDKSRC=${S}  
	PATH=$PATH:$_prefix/ee/bin:$_prefix/iop/bin:$_prefix/dvp/bin

	cd ${S}

	einfo "Starting make..."
	make || die "Make failed"

	if use doc; then
	  	einfo "making documentation"
		make docs
	fi

	einfo "Starting make release"
	make release || die "Make release failed"
	sleep 3
	einfo "Making ps2dev.sh environment script..."
	echo "export PS2DEV=\"$_prefix\"" > 9999-ps2dev
	echo "export PS2SDK=\"$_prefix/ps2sdk\"" >> 9999-ps2dev
	echo "export PS2SDKSRC=\"$_prefix/src/ps2sdk\"" >> 9999-ps2dev
	echo "export PATH=\"$PATH:$_prefix/ps2sdk/bin\"" >> 9999-ps2dev

	insinto /etc/env.d
	doins 9999-ps2dev || die "env script install failed"

	if use source; then
	  einfo "Copying sources to ps2dev/src..."
	  make clean
	  install -m755 -d ${D}/opt/ps2dev/src
	  cp -r * ${D}/opt/ps2dev/src/$_svnmod
	fi

}

pkg_postinst() {
	einfo "doing post-installation crt0 links"
	source /etc/env.d/9999-ps2dev
	ln -sf $PS2SDK/ee/startup/crt0.o $PS2DEV/ee/lib/gcc-lib/ee/3.2.2/crt0.o
	ln -sf $PS2SDK/ee/startup/crt0.o $PS2DEV/ee/ee/lib/crt0.o
}
