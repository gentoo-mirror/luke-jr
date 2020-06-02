# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unpacker for pbzx-format macOS disk images"
HOMEPAGE="https://github.com/NiklasRosenstein/pbzx"
SRC_URI="https://github.com/NiklasRosenstein/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~amd64 ~ppc64"

IUSE=""

RDEPEND="
	app-arch/xar:=
	app-arch/xz-utils:=
"
DEPEND="${RDEPEND}"

src_compile() {
	local libs=(
		$(pkg-config liblzma --cflags --libs)
		-lxar
	)
	echo $(tc-getCC) ${CFLAGS} "${libs[@]}" -o "${PN}" ${LDFLAGS} "${PN}".c
	$(tc-getCC) ${CFLAGS} "${libs[@]}" -o "${PN}" ${LDFLAGS} "${PN}".c || die
}

src_install() {
	into /usr
	dobin "${PN}"
	default
}
