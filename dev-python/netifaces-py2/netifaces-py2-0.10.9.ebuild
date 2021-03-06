# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit distutils-py2

DESCRIPTION="Portable network interface information"
HOMEPAGE="
	https://pypi.org/project/netifaces/
	https://alastairs-place.net/projects/netifaces/
	https://github.com/al45tair/netifaces
"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND="
	!!dev-python/netifaces[python_targets_python2_7(-)]
	|| ( dev-python/setuptools-py2[${PYTHON_USEDEP}] dev-python/setuptools[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${MY_PN}-0.10.4-remove-osx-fix.patch )
