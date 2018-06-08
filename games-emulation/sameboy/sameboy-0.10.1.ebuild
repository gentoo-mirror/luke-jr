# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A user friendly Game Boy and Game Boy Color emulator"
HOMEPAGE="https://sameboy.github.io/"
SRC_URI="https://github.com/LIJI32/SameBoy/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="
	media-libs/libsdl2:=
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-lang/rgbds
"

S="${WORKDIR}/SameBoy-${PV}"

src_prepare() {
	eapply "${FILESDIR}/usr_share.patch"
	default
}

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu11 -D_GNU_SOURCE -DVERSION="${PV}" -I. -D_USE_MATH_DEFINES" LDFLAGS="${LDFLAGS} -lc -lm" CC="$(tc-getCC)" || die
}

src_install() {
	cd build/bin/SDL || die
	exeinto /usr/bin
	doexe sameboy
	rm sameboy LICENSE || die
	insinto "/usr/share/${PN}"
	doins -r *
}
