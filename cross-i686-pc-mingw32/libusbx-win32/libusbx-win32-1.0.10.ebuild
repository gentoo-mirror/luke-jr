EAPI=4

DESCRIPTION="A library that provides generic access to USB devices"
HOMEPAGE="http://libusbx.org/"
LICENSE="LGPL-2.1"

MyPN="${PN/-win32/}"
MyP="${MyPN}-${PV}"
SRC_URI="mirror://sourceforge/${MyPN}/releases/${PV}/Windows/${MyP}-win.7z"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"

IUSE="+static-libs"

RDEPEND=""
DEPEND="app-arch/p7zip"

S="${WORKDIR}"

# FIXME: actually build it :p

myARCH="${CATEGORY/cross-/}"

src_install() {
	insinto "/usr/${myARCH}/usr/include/libusb-1.0"
	doins include/libusbx-1.0/libusb.h
	into "/usr/${myARCH}/usr"
	dolib.so "MinGW32/dll/libusb-1.0.dll"
	mv "${D}/usr/${myARCH}/usr/"{lib,bin} || die
	if use static-libs; then
		dolib.a "MinGW32/static/libusb-1.0.a"
		dolib.a "MinGW32/dll/libusb-1.0.dll.a"
	fi
}
