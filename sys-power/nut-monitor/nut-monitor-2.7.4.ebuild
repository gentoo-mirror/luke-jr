# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit desktop fixheadtails python-single-r1

MY_P="nut-${PV}"

DESCRIPTION="Network-UPS Tools"
HOMEPAGE="https://www.networkupstools.org/"
SRC_URI="https://networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygtk[${PYTHON_MULTI_USEDEP}]
	')
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply "${FILESDIR}"/NUT-Monitor-1.3-paths.patch

	default
}

src_configure() {
	true
}

src_install() {
	python_fix_shebang scripts/python/app
	python_domodule scripts/python/module/PyNUT.py
	python_doscript scripts/python/app/NUT-Monitor

	insinto /usr/share/nut
	doins scripts/python/app/gui-1.3.glade

	dodir /usr/share/nut/pixmaps
	insinto /usr/share/nut/pixmaps
	doins scripts/python/app/pixmaps/*

	sed -i -e 's/nut-monitor.png/nut-monitor/' -e 's/Application;//' \
		scripts/python/app/${PN}.desktop || die

	doicon scripts/python/app/${PN}.png
	domenu scripts/python/app/${PN}.desktop
}
