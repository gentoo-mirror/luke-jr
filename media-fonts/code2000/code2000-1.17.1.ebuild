# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit font

DESCRIPTION="TrueType font covering all of the CJK ideographs in the Basic Multilingual Plane of Unicode"
HOMEPAGE="http://sourceforge.net/projects/code2000/"
SRC_URI="mirror://sourceforge/code2000/code2000.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

DEPEND="$DEPEND
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="ttf"
S="${WORKDIR}"
FONT_S="${S}"

RESTRICT="strip binchecks"

src_prepare() {
	for n in 0 1 2; do
		mv "CODE200$n.TTF" "code200$n.ttf"
	done
}
