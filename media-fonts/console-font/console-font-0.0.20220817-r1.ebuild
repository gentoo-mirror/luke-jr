# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Console font"
HOMEPAGE=""
SRC_URI="https://luke.dashjr.org/education/tonal/glyphs/fonts/Console/luke.console8x16-20220817.sfd -> ${P}.sfd"

LICENSE="public-domain" # bitmap font, not copyrightable
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="+bdf +otb"
REQUIRED_USE="|| ( bdf otb )"

DEPEND="media-gfx/fontforge"

S="${WORKDIR}"
FONT_S="${S}"

FONT_SUFFIX="bdf otb"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}" || die
}

src_prepare() {
	echo 'Open($1); Generate($2)' >"build.pe" || die
	default
}

src_compile() {
	FONT_SUFFIX=
	for fmt in bdf otb; do
		if use $fmt; then
			fontforge -script build.pe *.sfd ConsoleMedium.$fmt || die
			FONT_SUFFIX="$FONT_SUFFIX $fmt"
		fi
	done
}
