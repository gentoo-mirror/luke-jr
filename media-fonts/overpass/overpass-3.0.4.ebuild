# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit font

MY_PN='Overpass'
COMMITHASH='8e31ae8dce623f1c8c2cb5d69b99f1b339c3dcec'

DESCRIPTION="An open source webfont family inspired by Highway Gothic"
HOMEPAGE="http://overpassfont.org/"
SRC_URI="https://github.com/RedHatOfficial/${MY_PN}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 OFL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

S="${WORKDIR}/${MY_PN}-${COMMITHASH}/webfonts/overpass-webfont"
FONT_SUFFIX="ttf"

src_prepare() {
	# Match filenames used in 2.1
	local style style_in
	for style in 'ExtraLight Italic' ExtraLight Bold-Italic Bold Light Light-Italic Regular; do
		style_in=$(tr 'A-Z' 'a-z' <<<"${style/ /-}")
		mv -v "overpass-${style_in}.ttf" "Overpass-${style}.ttf" || die
	done
	mv -v overpass-italic.ttf "Overpass-Regular-Italic.ttf" || die
	default
}
