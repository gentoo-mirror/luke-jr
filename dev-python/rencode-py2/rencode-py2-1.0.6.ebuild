# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

DESCRIPTION="similar to bencode from the BitTorrent project"
HOMEPAGE="https://github.com/aresch/rencode"
SRC_URI="https://github.com/aresch/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="
	!!dev-python/rencode[python_targets_python2_7(-)]
	|| ( dev-python/cython-py2[${PYTHON_USEDEP}] dev-python/cython[${PYTHON_USEDEP}] )
	|| ( dev-python/wheel-py2[${PYTHON_USEDEP}] dev-python/wheel[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"
