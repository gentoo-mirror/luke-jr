EAPI=4

inherit eutils

DESCRIPTION=""
HOMEPAGE="http://pdcurses.sourceforge.net/"
LICENSE="public-domain"

MyPN="PDCurses"
MyP="${MyPN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MyP}.tar.gz"
SLOT="0"
KEYWORDS="~x86"

IUSE="debug static-libs unicode"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MyP}"

myARCH="${CATEGORY/cross-/}"

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}/${PV}-resize-fix.patch"
	sed -i '
		s/\\exp/\/exp/;
		s/del /rm /;
		s/type /cat /;
		s/copy /cp /;
		s/\$?/$? -lgdi32/;
	' win32/mingwin32.mak
}

src_configure() {
	true  # Ignore configure script
}

src_compile() {
	cd "${S}/win32"
	local OPTS=()
	OPTS+=("-f" "mingwin32.mak")
	OPTS+=("CC=${myARCH}-gcc")
	OPTS+=("LIBEXE=${myARCH}-gcc pdcurses.def")
	OPTS+=("DEBUG=$(use debug && echo Y || echo N)")
	OPTS+=($(use unicode && echo WIDE=Y UTF8=Y || echo WIDE=N UTF8=N))
	make "${OPTS[@]}" DLL=Y libs
	if use static-libs; then
		mv pdcurses.dll dll
		make "${OPTS[@]}" DLL=Y clean
		mv dll pdcurses.dll
		make "${OPTS[@]}" DLL=N libs
	fi
}

src_install() {
	insinto "/usr/${myARCH}/usr/include"
	doins curses.h panel.h
	into "/usr/${myARCH}/usr"
	dolib win32/pdcurses.dll
}
