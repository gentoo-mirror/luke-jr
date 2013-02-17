# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit bzr distutils

DESCRIPTION="Meliae is a library meant to help people understand how their memory is being used in Python"
HOMEPAGE="https://launchpad.net/meliae/"
EBZR_REPO_URI="lp:meliae"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	distutils_src_install
	mv "${D}/usr/bin/"{,meliae_}"strip_duplicates.py"
}
