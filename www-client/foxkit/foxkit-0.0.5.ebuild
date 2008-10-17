# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

NEED_KDE=":4.1"
inherit kde4-base

DESCRIPTION="A cross-platform Qt4 WebKit browser"
HOMEPAGE="http://foxkit.googlecode.com/"
SRC_URI="http://foxkit.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( GPL-3 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-webkit:4"
DEPEND="$RDEPEND"

PATCHES="${FILESDIR}/${P}-pointer-stringify-fix.patch"
