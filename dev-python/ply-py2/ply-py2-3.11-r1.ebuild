# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

DESCRIPTION="Python Lex-Yacc library"
HOMEPAGE="http://www.dabeaz.com/ply/ https://pypi.org/project/ply/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

RDEPEND="
	!!dev-python/ply[python_targets_python2_7(-)]
"

S="${WORKDIR}/${MY_P}"

DOCS=( ANNOUNCE CHANGES TODO )

PATCHES=( "${FILESDIR}/3.6-picklefile-IOError.patch" )

python_test() {
	cp -r -l test "${BUILD_DIR}"/ || die
	cd "${BUILD_DIR}"/test || die

	# Checks for pyc/pyo files
	local -x PYTHONDONTWRITEBYTECODE=

	local t
	for t in testlex.py testyacc.py; do
		"${EPYTHON}" "${t}" -v || die "${t} fails with ${EPYTHON}"
	done
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	use examples && dodoc -r example
	distutils-r1_python_install_all
}
