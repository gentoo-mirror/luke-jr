# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"
MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/pypa/setuptools.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.zip"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Collection of extensions to Distutils"
HOMEPAGE="https://github.com/pypa/setuptools https://pypi.org/project/setuptools/"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	!!dev-python/setuptools[python_targets_python2_7(-)]
"
RDEPEND="${DEPEND}
	dev-python/setuptools
"

BDEPEND="
	app-arch/unzip
"
PDEPEND="
	|| ( >=dev-python/certifi-py2-2016.9.26[${PYTHON_USEDEP}] >=dev-python/certifi-2016.9.26[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

# Force in-source build because build system modifies sources.
DISTUTILS_IN_SOURCE_BUILD=1

DOCS=( {CHANGES,README}.rst docs/{easy_install.txt,pkg_resources.txt,setuptools.txt} )

PATCHES=(
	# fix regression introduced by reinventing deprecated 'imp'
	# https://github.com/pypa/setuptools/pull/1905
	"${FILESDIR}"/setuptools-42.0.0-imp-fix.patch
)

python_prepare_all() {
	if [[ ${PV} == "9999" ]]; then
		python_setup
		${EPYTHON} bootstrap.py || die
	fi

	# disable tests requiring a network connection
	rm setuptools/tests/test_packageindex.py || die

	# don't run integration tests
	rm setuptools/tests/test_integration.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	if ! python_is_python3; then
		einfo "Tests are skipped on py2 to untangle deps"
		return
	fi

	# test_easy_install raises a SandboxViolation due to ${HOME}/.pydistutils.cfg
	# It tries to sandbox the test in a tempdir
	HOME="${PWD}" pytest -vv "${MY_PN}" || die "Tests failed under ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	# We recycle the wrapper installed by the Py3 setuptools
	rm "${D}/usr/bin/easy_install" || die
}

python_install() {
	export DISTRIBUTE_DISABLE_VERSIONED_EASY_INSTALL_SCRIPT=1
	distutils-py2_python_install
}
