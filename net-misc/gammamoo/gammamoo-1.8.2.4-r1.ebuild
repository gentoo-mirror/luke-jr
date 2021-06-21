# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic

MyPV="1.8.2g4"
MyP="${PN}-${MyPV}"

DESCRIPTION="A modern MOO server, based on LambdaMOO"
HOMEPAGE="http://luke.dashjr.org/programs/${PN}/"
SRC_URI="http://luke.dashjr.org/programs/${PN}/download/${MyP}.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~sparc"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""

S="${WORKDIR}/MOO-${MyPV}"

src_configure() {
	append-cflags -fcommon
	default
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	newbin moo gammamoo
	dodoc *.txt README* BUGS Minimal.db

	newinitd "${FILESDIR}"/gammamoo.rc ${PN}
	newconfd "${FILESDIR}"/gammamoo.conf ${PN}
}
