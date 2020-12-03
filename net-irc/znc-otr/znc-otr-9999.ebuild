# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 multilib

ZNC_COMMITHASH="11560d6700bdc57241968ada2f44f99220ef0bf6"

DESCRIPTION="Encrypt private conversations using the OTR protocol, on a ZNC server"
HOMEPAGE="https://wiki.znc.in/Otr"
EGIT_REPO_URI="https://github.com/luke-jr/znc-otr.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

IUSE=""

DEPEND="
	net-irc/znc:=
	net-libs/libotr
"
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/$(get_libdir)/znc
	insopts '-m0755'
	doins otr.so
}
