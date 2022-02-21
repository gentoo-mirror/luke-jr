# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_8 python3_9 )

inherit desktop fixheadtails python-single-r1

COMMITHASH="bb73c54b50ecd3b2eb961e9082086b8934a0b86b"

DESCRIPTION="GUI to manage devices connected a NUT server"
HOMEPAGE="https://www.networkupstools.org/"
SRC_URI="https://github.com/luke-jr/nut/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/PyQt5[${PYTHON_USEDEP}]
	')
"

S="${WORKDIR}/nut-${COMMITHASH}/scripts/python"

src_prepare() {
	eapply -p3 "${FILESDIR}"/NUT-Monitor-2.0-paths.patch

	default
}

src_configure() {
	true
}

src_install() {
	for f in module/PyNUT.py app/NUT-Monitor; do
		{ echo "#!${PYTHON}"; cat "$f.in"; } >"$f" || die
		python_fix_shebang "$f"
	done
	python_domodule module/PyNUT.py
	python_doscript app/NUT-Monitor

	insinto /usr/share/NUT-Monitor/ui
	doins app/ui/*.ui

	dodir /usr/share/NUT-Monitor/pixmaps
	insinto /usr/share/NUT-Monitor/pixmaps
	doins app/pixmaps/*

	for size in 48x48 64x64 256x256 scalable; do
		doicon -s "${size}" "app/icons/${size}/${PN}".??g
	done
	domenu "app/${PN}.desktop"
}
