# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/s/S}"

inherit font

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="https://web.archive.org/web/20180212144935/http://users.teilar.gr:80/~g1951d"
SRC_URI="https://luke.dashjr.org/mirror/misc/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="doc"
RESTRICT="mirror bindist"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	if use doc; then
		DOCS="${MY_PN}.pdf"
	fi
	default
}
