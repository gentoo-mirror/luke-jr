# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

MyP="${P/_p/r}-linux"
DESCRIPTION="Prince is a computer program that converts XML and HTML into PDF documents."
HOMEPAGE="http://www.princexml.com/"
SRC_URI="http://www.princexml.com/download/${MyP}.tar.gz"
LICENSE="Prince-EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MyP}"

QA_PREBUILT="/usr/lib/prince/bin/prince"

src_prepare() {
	eapply "${FILESDIR}/destdir.patch"
	default
}

src_install() {
	DESTDIR="${D}" ./install.sh <<<'/usr'
}
