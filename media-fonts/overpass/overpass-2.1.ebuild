# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit font

DESCRIPTION="An open source webfont family inspired by Highway Gothic"
HOMEPAGE="http://overpassfont.org/"
SRC_URI="https://github.com/RedHatBrand/${PN}/releases/download/${PV}/${PN}-fonts-ttf-${PV}.zip"

LICENSE="|| ( LGPL-2.1 OFL-1.1 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"

S="${WORKDIR}/${PN}-fonts-ttf-${PV}"
FONT_SUFFIX="ttf"
