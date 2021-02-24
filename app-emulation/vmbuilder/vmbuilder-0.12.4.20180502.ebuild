# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_{5,6,7} )
DISTUTILS_SINGLE_IMPL=1

inherit git-r3 distutils-py2

EGIT_REPO_URI="https://github.com/newroco/vmbuilder.git"
EGIT_COMMIT='bbf1921aa090eb924379cca38838d7bb8009a781'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DESCRIPTION="Install virtual machines in a snap without ever actually booting a virtual machine!"
HOMEPAGE="https://github.com/newroco/vmbuilder"
LICENSE="GPL-3"

RDEPEND="
	>=dev-util/debootstrap-1.0.9
	${PYTHON_DEPS}
	app-emulation/qemu
	net-misc/rsync
	$(python_gen_cond_dep '
		dev-python/cheetah[${PYTHON_MULTI_USEDEP}]
	')
	sys-block/parted
	sys-fs/multipath-tools
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# python-central

src_prepare() {
	eapply "${FILESDIR}/kernel_arch.patch"
	default
}
