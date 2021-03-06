# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2 prefix

DESCRIPTION="Python interface to lzo"
HOMEPAGE="https://github.com/jd-boyd/python-lzo"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/lzo:2"
DEPEND="${RDEPEND}
	!!dev-python/python-lzo[python_targets_python2_7(-)]
"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:test_version:_&:' tests/test.py || die
	hprefixify setup.py
	distutils-r1_src_prepare
}

python_test() {
	pytest -vv tests/test.py || die "Tests failed with ${EPYTHON}"
}
