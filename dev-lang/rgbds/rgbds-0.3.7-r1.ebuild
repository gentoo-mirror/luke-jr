# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Free assembler/linker package for the Game Boy and Game Boy Color"
HOMEPAGE="https://rednex.github.io/rgbds/"
SRC_URI="https://github.com/rednex/${PN}/releases/download/v${PV}/${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="
	media-libs/libpng:=
"
DEPEND="${RDEPEND}
	app-alternatives/yacc
	sys-devel/flex
	virtual/pkgconfig
"

src_prepare() {
	default
	append-cflags -fcommon
}

src_compile() {
	emake Q= CFLAGS="${CFLAGS}" || die
}

src_install() {
	emake Q= CFLAGS="${CFLAGS}" STRIP= DESTDIR="${D}" PREFIX=/usr mandir=/usr/share/man install || die
}
