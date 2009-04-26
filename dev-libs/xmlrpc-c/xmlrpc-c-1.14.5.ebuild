# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlrpc-c/xmlrpc-c-1.06.09-r2.ebuild,v 1.1 2008/04/22 18:38:49 cardoe Exp $

EAPI=1

inherit eutils subversion

DESCRIPTION="A lightweight RPC library based on XML and HTTP"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/advanced/"
ESVN_REVISION='1469'
ESVN_UP_FREQ='10000' # Fixed revision will never change :)
ESVN_PROJECT="${P}"
HOMEPAGE="http://${PN}.sourceforge.net/"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="+curl libwww threads"
LICENSE="BSD"
SLOT="0"

DEPEND="dev-libs/libxml2
	libwww? ( net-libs/libwww
			>=dev-libs/openssl-0.9.8g )
	curl? ( net-misc/curl )"

pkg_setup() {
	if ! use curl && ! use libwww; then
		ewarn "Neither CURL nor libwww support was selected"
		ewarn "No client library will be be built"
	fi
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.05-pic.patch

	# Respect the user's CFLAGS/CXXFLAGS.
	sed -i -e "/CFLAGS_COMMON/s:-g -O3$:${CFLAGS}:" Makefile.common
	sed -i -e "/CXXFLAGS_COMMON/s:-g$:${CXXFLAGS}:" Makefile.common
}

src_compile() {
	# Respect the user's LDFLAGS.
	export LADD=${LDFLAGS}
	econf --disable-wininet-client --enable-libxml2-backend \
		$(use_enable threads abyss-threads) \
		$(use_enable curl curl-client) \
		$(use_enable libwww libwww-client) || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "installation failed"

	dodoc README doc/CREDITS doc/DEVELOPING doc/HISTORY doc/SECURITY doc/TESTING \
		doc/TODO || die "installing docs failed"
}