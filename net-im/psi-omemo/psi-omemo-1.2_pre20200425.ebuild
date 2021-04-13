# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN#psi-}plugin"
EGIT_REPO_URI="https://github.com/psi-im/plugins.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/plugins"
EGIT_COMMIT="8b345ca0fb27dfad40337af648973ea3b8c9def7"
inherit qmake-utils git-r3
HOMEPAGE="https://github.com/psi-im/"
SRC_URI=""
DESCRIPTION="Psi plugin for OMEMO"
LICENSE="GPL-2"
SLOT="0"
DEPEND="=net-im/psi-1.4.1100"
RDEPEND="${DEPEND}"

KEYWORDS=""
IUSE=""

S="${WORKDIR}/plugins/generic/${MY_PN}"

RDEPEND="
	|| ( >=net-libs/libsignal-protocol-c-2.3.1_p20180209 >=app-crypt/libsignal-protocol-c-2.3.1_p20180209 )
	>=app-crypt/qca-2.1.3_p20180105"
DEPEND="$RDEPEND"

src_prepare() {
	default
	sed -e 's#\.\./\.\./psiplugin.pri#/usr/share/psi-plus/plugins/psiplugin.pri#' -i "${MY_PN}".pro || die
}

src_configure() {
	eqmake5 "${MY_PN}".pro
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
