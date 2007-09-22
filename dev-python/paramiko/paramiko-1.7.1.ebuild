# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils


DESCRIPTION="SSH2 protocol library"
HOMEPAGE="http://www.lag.net/paramiko/"
SRC_URI="http://www.lag.net/paramiko/download/${P}.zip"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""
DEPEND="dev-python/setuptools"
RDEPEND=">=dev-python/pycrypto-1.9"

src_test() {
	PYTHONPATH=. "${python}" setup.py test || die "tests failed"
}

