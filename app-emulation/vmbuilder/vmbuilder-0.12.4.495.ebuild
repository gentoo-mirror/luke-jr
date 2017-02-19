# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_{5,6,7} )
DISTUTILS_SINGLE_IMPL=1

inherit bzr distutils-r1

EBZR_REPO_URI="lp:${PN}"
EBZR_REVISION=495
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DESCRIPTION="Install virtual machines in a snap without ever actually booting a virtual machine!"
HOMEPAGE="https://launchpad.net/vmbuilder"
LICENSE="GPL-3"

RDEPEND="
	>=dev-util/debootstrap-1.0.9
	${PYTHON_DEPS}
	app-emulation/qemu
	net-misc/rsync
	dev-python/cheetah[${PYTHON_USEDEP}]
	sys-block/parted
	sys-fs/multipath-tools
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# python-central

src_prepare() {
	epatch "${FILESDIR}/kernel_arch.patch"
}
