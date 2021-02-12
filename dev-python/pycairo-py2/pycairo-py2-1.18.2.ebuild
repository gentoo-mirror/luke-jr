# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

DESCRIPTION="Python2 bindings for the cairo library"
HOMEPAGE="https://www.cairographics.org/pycairo/ https://github.com/pygobject/pycairo"
SRC_URI="https://github.com/pygobject/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples"

RDEPEND="
	!!dev-python/pycairo[python_targets_python2_7(-)]
	>=x11-libs/cairo-1.13.1[svg]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
distutils_enable_tests setup.py

python_test() {
	if ! python_is_python3; then
		einfo "Skipping tests on Python 2 to unblock deps"
		return
	fi
}

python_install() {
	distutils-py2_python_install \
		install_pkgconfig --pkgconfigdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
	fi

	distutils-r1_python_install_all
}
