# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font font-ebdftopcf

DESCRIPTION="Console font"
HOMEPAGE=""
SRC_URI="https://luke.dashjr.org/education/tonal/glyphs/fonts/Console/luke.console8x16.sfd -> ${P}.sfd"

LICENSE="public-domain" # bitmap font, not copyrightable
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="media-gfx/fontforge"

S="${WORKDIR}"
FONT_S="${S}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}" || die
}

src_prepare() {
	echo 'Open($1); Generate($2)' >"build.pe" || die
	default
}

src_compile() {
	fontforge -script build.pe *.sfd ConsoleMedium.bdf || die
	font-ebdftopcf_src_compile
}
