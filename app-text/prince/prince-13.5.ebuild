# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Prince is a computer program that converts XML and HTML into PDF documents."
HOMEPAGE="https://www.princexml.com/"
SRC_URI="
	amd64? ( https://www.princexml.com/download/${P}-linux-generic-x86_64.tar.gz )
	x86? ( https://www.princexml.com/download/${P}-linux-generic-i686.tar.gz )
"

LICENSE="Prince-13.5-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/fontconfig:1.0
"
QA_PRESTRIPPED="usr/lib/prince/.*"

src_unpack() {
	default
	mv "${P}"-linux-generic-* "${S}" || die
}

src_prepare() {
	eapply "${FILESDIR}/destdir.patch"
	default
}

src_install() {
	DESTDIR="${D}" ./install.sh <<<'/usr'
}
