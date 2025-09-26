# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_12 python3_13 )
DISTUTILS_USE_PEP517="setuptools"

inherit git-r3 systemd python-r1 distutils-r1


DESCRIPTION="ds4drv is a Sony DualShock 4 userspace driver for Linux"
HOMEPAGE="https://github.com/clearpathrobotics/ds4drv"
EGIT_REPO_URI="https://github.com/clearpathrobotics/ds4drv"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-python/pyudev-0.16[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/evdev-0.3.0[${PYTHON_USEDEP}]
	net-wireless/bluez
"
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	systemd_dounit "${S}"/systemd/ds4drv.service
		insinto "/etc"
		doins "${S}"/ds4drv.conf
}

