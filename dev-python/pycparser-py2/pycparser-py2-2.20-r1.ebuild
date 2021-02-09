# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="https://github.com/eliben/pycparser"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| ( dev-python/ply-py2:=[${PYTHON_USEDEP}] dev-python/ply:=[${PYTHON_USEDEP}] )
	!!dev-python/pycparser[python_targets_python2_7(-)]
"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# remove the original files to guarantee their regen
	rm pycparser/{c_ast,lextab,yacctab}.py || die

	# kill sys.path manipulations to force the tests to use built files
	sed -i -e '/sys\.path/d' tests/*.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-py2_python_compile

	# note: tables built by py3.5+ are incompatible with older versions
	# because of 100 group limit of 're' module -- just generate them
	# separately optimized for each target instead
	pushd "${BUILD_DIR}"/lib/pycparser > /dev/null || die
	"${PYTHON}" _build_tables.py || die
	popd > /dev/null || die
}

python_test() {
	# Skip tests if cpp is not in PATH
	type -P cpp >/dev/null || return 0
	# change workdir to avoid '.' import
	cd tests || die
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-py2_python_install

	# setup.py generates {c_ast,lextab,yacctab}.py with bytecode disabled.
	python_optimize
}
