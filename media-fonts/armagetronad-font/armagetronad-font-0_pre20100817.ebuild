# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font xdg-utils

DESCRIPTION="Font designed for games-action/armagetronad console"
HOMEPAGE="http://armagetronad.org/"

MY_COMMIT="586f0d34efa7ec7d890224ce9d7ace1533b9428b"
SRC_URI="
	fontforge? ( https://gitlab.com/armagetronad/armagetronad/-/raw/${MY_COMMIT}/textures/armagetronad.sfd -> ${P}.sfd )
	!fontforge? ( https://gitlab.com/armagetronad/armagetronad/-/raw/${MY_COMMIT}/textures/Armagetronad.ttf -> ${P}.ttf )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~m68k-mint"
IUSE="fontforge"

DEPEND="
	fontforge? (
		media-gfx/fontforge
	)
"

S="${WORKDIR}"

FONT_SUFFIX="ttf"

src_unpack() {
	if ! use fontforge; then
		cp "${DISTDIR}/${A}" "${PN}.ttf" || die
	fi
}

src_compile() {
	if use fontforge; then
		fontforge -script "${FILESDIR}"/${PN}.pe "${DISTDIR}/${A}" "${PN}.ttf" || die
	fi
}
