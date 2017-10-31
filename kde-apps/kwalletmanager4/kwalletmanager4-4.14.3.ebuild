# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kwalletmanager"

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Wallet Management Tool"
HOMEAGE="https://www.kde.org/applications/system/kwalletmanager
https://utils.kde.org/projects/kwalletmanager"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="kde-apps/kwalletmanager"  # for icons
RDEPEND="!kde-base/kwallet:4
	kde-apps/kwalletd:4
"

S="${WORKDIR}/${KMNAME}-${PV}"

src_install() {
	kde4-base_src_install

	rm -r "${D}/usr/share/icons"
}
