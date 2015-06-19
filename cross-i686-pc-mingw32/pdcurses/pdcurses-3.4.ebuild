EAPI=4

DESCRIPTION=""
HOMEPAGE="http://pdcurses.sourceforge.net/"
LICENSE="public-domain"

SRC_URI="mirror://sourceforge/pdcurses/pdcurses/3.4/pdc34dllw.zip"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# FIXME: actually build it :p

myARCH="${CATEGORY/cross-/}"

src_install() {
	insinto "/usr/${myARCH}/usr/include"
	doins curses.h panel.h
	into "/usr/${myARCH}/usr"
	newlib.a pdcurses.lib libpdcurses.a
}
