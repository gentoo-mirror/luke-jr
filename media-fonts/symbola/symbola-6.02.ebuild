# Copyright 2011 Luke Dashjr
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="OpenType font covering many Unicode symbols"
HOMEPAGE="http://users.teilar.gr/~g1951d/"
MyPN='Symbola'
MyPV="${PV/./}"
MyP="${MyPN}${MyPV}"
SRC_URI="http://users.teilar.gr/~g1951d/${MyP}.zip"

LICENSE="GeorgeDouro"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="$DEPEND
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="otf"
S="${WORKDIR}"
FONT_S="${S}"
DOCS="${MyP}.txt ${MyPN}601.pdf"

RESTRICT="strip binchecks"
