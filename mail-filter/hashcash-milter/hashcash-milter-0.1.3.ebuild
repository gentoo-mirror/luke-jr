# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic toolchain-funcs user

DESCRIPTION="A milter-based application to mint and check Hashcash stamps"
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

src_prepare() {
	eapply "${FILESDIR}/bugfix_rfc2822_skip_comment_missing_break.patch"
	eapply "${FILESDIR}/bugfix_util_format_date_missing_braces.patch"

	default
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
