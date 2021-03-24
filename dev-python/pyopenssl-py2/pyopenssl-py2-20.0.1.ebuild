# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-py2 flag-o-matic

MY_PN=pyOpenSSL
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://pypi.org/project/pyOpenSSL/
	https://github.com/pyca/pyopenssl/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="!!dev-python/pyopenssl[python_targets_python2_7(-)]"
RDEPEND="
	|| ( >=dev-python/six-py2-1.5.2[${PYTHON_USEDEP}] >=dev-python/six-1.5.2[${PYTHON_USEDEP}] )
	|| ( >=dev-python/cryptography-py2-3.2[${PYTHON_USEDEP}] >=dev-python/cryptography-3.2[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		|| ( dev-python/cffi-py2[${PYTHON_USEDEP}] virtual/python-cffi[${PYTHON_USEDEP}] )
		|| ( dev-python/flaky-py2[${PYTHON_USEDEP}] dev-python/flaky[${PYTHON_USEDEP}] )
		|| ( dev-python/pretend-py2[${PYTHON_USEDEP}] dev-python/pretend[${PYTHON_USEDEP}] )
		|| ( >=dev-python/pytest-py2-3.0.1[${PYTHON_USEDEP}] >=dev-python/pytest-3.0.1[${PYTHON_USEDEP}] )
	)"

distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	# Requires network access
	sed -i -e 's/test_set_default_verify_paths/_&/' tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

src_test() {
	local -x TZ=UTC
	distutils-r1_src_test
}
