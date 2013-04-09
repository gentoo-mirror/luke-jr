# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils

MyPN="VMBuilder"
MyP="${MyPN}-${PV}"
SRC_URI="https://launchpad.net/${PN}/0.12/${PV}/+download/${MyP}.tar.gz"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DESCRIPTION="Install virtual machines in a snap without ever actually booting a virtual machine!"
HOMEPAGE="https://launchpad.net/vmbuilder"
LICENSE="GPL-3"

RDEPEND="
	>=dev-util/debootstrap-1.0.9
	>=dev-lang/python-2.5:2
	app-emulation/qemu
	net-misc/rsync
	dev-python/cheetah
	sys-block/parted
	sys-fs/multipath-tools
"
# python-central

S="${WORKDIR}/${MyP}"
