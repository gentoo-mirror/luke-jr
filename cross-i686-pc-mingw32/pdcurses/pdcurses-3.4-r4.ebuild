EAPI=4

inherit eutils

DESCRIPTION=""
HOMEPAGE="http://pdcurses.sourceforge.net/"
LICENSE="public-domain"

MyPN="PDCurses"
MyP="${MyPN}-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MyP}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
		s/\bar\b/$(AR)/;
		s/\bgcc\b/$(CC)/;
		s/^\([[:space:]]*\)\(CC[[:space:]]*=\)/\1#\2/;
	' win32/mingwin32.mak
}

src_configure() {
	true  # Ignore configure script
}

src_compile() {
	cd "${S}/win32"
	local OPTS=()
	OPTS+=("-f" "mingwin32.mak")
	[ "$myARCH" = "$CATEGORY" ] && myARCH="${CHOST}"
	OPTS+=("CC=${myARCH}-gcc")
	OPTS+=("AR=${myARCH}-ar")
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
	local subroot="/usr/${myARCH}"
	[ "${CATEGORY/cross/}" = "$CATEGORY" ] && subroot=
	insinto "${subroot}/usr/include"
	doins curses.h panel.h
	into "${subroot}/usr"
	dolib win32/pdcurses.dll
}
