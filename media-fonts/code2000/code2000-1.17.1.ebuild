# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="TrueType font covering all of the CJK ideographs in the Basic Multilingual Plane of Unicode"
HOMEPAGE="http://www.code2000.net/"
SRC_URI="http://code2000.net/CODE2000.ZIP"

LICENSE="Code2000"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="$DEPEND
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="ttf"
S="${WORKDIR}"
FONT_S="${S}"
DOCS="code2000.html"

RESTRICT="strip binchecks"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	mv "CODE2000.HTM" "code2000.html"
	mv "CODE2000.TTF" "code2000.ttf"
}
