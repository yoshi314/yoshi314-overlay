# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-mod-r1 toolchain-funcs

DESCRIPTION="Linux kernel module for Huion and compatible tablets"
HOMEPAGE="https://github.com/DIGImend/digimend-kernel-drivers"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	EGIT_REPO_URI="https://github.com/DIGImend/digimend-kernel-drivers"
else
	SRC_URI="https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v${PV}/digimend-kernel-drivers-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/digimend-kernel-drivers-${PV}"
fi

PATCHES=( "${FILESDIR}"/kernel-6.15.patch )


#MODULE_NAMES="hid-kye(extra:) hid-polostar(extra:) hid-uclogic(extra:) hid-viewsonic(extra:)"


LICENSE="GPL-2+"
SLOT="0"

DEPEND=""

RDEPEND="${DEPEND}"

DOCS=( README.md )

#pkg_setup() {
#	linux-mod_pkg_setup
#}

#src_prepare() {
#	default
#}
#
src_compile() {
	local modlist=( {hid-kye,hid-polostar,hid-uclogic,hid-viewsonic}=misc )
	set_arch_to_kernel
	myemakeargs=( V=1 modules )
	emake "${myemakeargs[@]}"
	linux-mod-r1_src_compile
}

#src_install() {
#	set_arch_to_kernel
#	linux-mod_src_install
#}
#
#pkg_postinst() {
#	linux-mod_pkg_postinst
#}
