# Copyright 1999-2021 Gentoo Authors
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
IUSE="demo"

RDEPEND="
	media-libs/fontconfig:1.0
"
QA_PRESTRIPPED="usr/lib/prince/.*"

PRINCE_LICENSEDIR="/usr/lib/prince/license/"
PRINCE_LICENSEFILE="${PRINCE_LICENSEDIR}/license.dat"

src_unpack() {
	default
	mv "${P}"-linux-generic-* "${S}" || die
}

src_prepare() {
	eapply "${FILESDIR}/destdir.patch"
	default
}

src_install() {
	DESTDIR="${ED}" ./install.sh <<<'/usr'

	doman "${ED}/usr/lib/prince/man"/*/*
	rm -rf "${ED}/usr/lib/prince/man"

	keepdir "${PRINCE_LICENSEDIR}"
	use demo || rm "${ED}${PRINCE_LICENSEFILE}"
}

pkg_postinst() {
	if ! ( use demo || [ -e "${PRINCE_LICENSEFILE}" ] ); then
		elog "Demo license has not been installed (USE flag 'demo')."
		elog "You must manually copy a license file to ${PRINCE_LICENSEFILE}"
	fi
}
