# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Tools for injecting arbitrary code into running Python processes"
HOMEPAGE="https://github.com/lmacken/pyrasite"
SRC_URI="https://github.com/lmacken/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ppc64 ~x86"
IUSE=""

RDEPEND="
	sys-devel/gdb
"
