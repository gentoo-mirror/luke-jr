# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple daemon which monitors XInput events and runs arbitrary scripts on hierarchy change events"
HOMEPAGE="https://github.com/andrewshadura/inputplug"
SRC_URI="https://github.com/andrewshadura/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc64"
IUSE=""

src_compile() {
	emake CFLAGS="${CFLAGS} -DHAVE_PIDFILE=1 -DHAVE_DAEMON=1"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
}
