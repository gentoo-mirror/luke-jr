# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="Twisted SSHv2 implementation"

KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="
	=dev-python/twisted-core-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]
	|| ( dev-python/pyasn1-py2[${PYTHON_USEDEP}] dev-python/pyasn1[${PYTHON_USEDEP}] )
	|| ( dev-python/pycrypto-py2[${PYTHON_USEDEP}] dev-python/pycrypto[${PYTHON_USEDEP}] )
"
RDEPEND="${DEPEND}
	dev-python/twisted
"

python_prepare_all() {
	if [[ "${EUID}" -eq 0 ]]; then
		# Disable tests failing with root permissions.
		sed -e "s/test_checkKeyAsRoot/_&/" -i twisted/conch/test/test_checkers.py
		sed -e "s/test_getPrivateKeysAsRoot/_&/" -i twisted/conch/test/test_openssh_compat.py
	fi

	distutils-r1_python_prepare_all
}

src_install() {
       distutils-r1_src_install

       # We recycle the wrappers installed by the Py3 version
       rm "${D}/usr/bin/"{cftp,ckeygen,conch,tkconch} || die
}
