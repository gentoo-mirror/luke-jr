# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs user

DESCRIPTION="A milter-based application to mint and check HashCash stamps"
HOMEPAGE="http://althenia.net/hashcash"
SRC_URI="http://althenia.net/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="sys-libs/db
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup milter
	# mail-milter/spamass-milter creates milter user with this home directory
	# For consistency reasons, milter user must be created here with this home directory
	# even though this package doesn't need a home directory for this user (#280571)
	enewuser milter -1 -1 /var/lib/milter milter
}

src_configure() {
	local CC="$(tc-getCC)"
	append-ldflags $(no-as-needed)
	einfo ./configure CC="$(tc-getCC)" CFLAGS="-D_GNU_SOURCE ${CFLAGS}" LDFLAGS="${LDFLAGS}"
	./configure CC="$(tc-getCC)" CFLAGS="-D_GNU_SOURCE ${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_compile() {
	emake
}

src_install() {
	dobin hashcash-milter

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	dodoc CHANGES README
}
