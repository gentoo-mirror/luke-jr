# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-py2

DESCRIPTION="Python bindings for the CUPS API"
HOMEPAGE="http://cyberelk.net/tim/data/pycups/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86"
SLOT="0"
IUSE="examples"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}
	!!dev-python/pycups[python_targets_python2_7(-)]
"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
