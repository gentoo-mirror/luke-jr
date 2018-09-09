# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

ZNC_COMMITHASH="11560d6700bdc57241968ada2f44f99220ef0bf6"

DESCRIPTION="Encrypt private conversations using the OTR protocol, on a ZNC server"
HOMEPAGE="https://wiki.znc.in/Otr"
SRC_URI="https://github.com/mmilata/${PN}/archive/${ZNC_COMMITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="
	net-irc/znc
	net-libs/libotr
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${ZNC_COMMITHASH}"

src_prepare() {
	eapply "${FILESDIR}/cstring-bugfix.patch"
	default
}

src_install() {
	insinto /usr/$(get_libdir)/znc
	insopts '-m0755'
	doins otr.so
}
