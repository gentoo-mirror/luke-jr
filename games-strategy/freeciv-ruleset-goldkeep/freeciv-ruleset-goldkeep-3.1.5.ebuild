# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Goldkeep ruleset for Freeciv (formerly known as 'experimental')"
HOMEPAGE="https://www.freeciv.org/ https://github.com/freeciv/freeciv/"

MY_PV="R${PV//./_}"
SRC_URI="https://github.com/freeciv/freeciv/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/freeciv-${MY_PV}/data"

LICENSE="GPL-2+"

SLOT="0"

KEYWORDS="amd64 ~ppc64 ~x86"

DEPEND="!<games-strategy/freeciv-3.1"
RDEPEND="=games-strategy/freeciv-3.1*"

src_install() {
	insinto "/usr/share/freeciv"
	doins -r experimental*
}
