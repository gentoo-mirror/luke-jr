# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils subversion

MY_P="${P/_/}"

DESCRIPTION="A small C library that makes it easy to run an HTTP server as part of another application."
HOMEPAGE="http://www.gnu.org/software/libmicrohttpd/"
ESVN_REPO_URI="https://gnunet.org/svn/${PN}@33603"

IUSE="epoll messages ssl static-libs test"
KEYWORDS=""
LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="ssl? (
		dev-libs/libgcrypt:0
		net-libs/gnutls
	)"

DEPEND="${RDEPEND}
	test?	(
		ssl? ( >=net-misc/curl-7.25.0-r1[ssl] )
	)"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README ChangeLog"

ESVN_BOOTSTRAP="./bootstrap"
ESVN_PATCHES="33603.patch"

src_configure() {
	econf \
		--enable-bauth \
		--enable-dauth \
		--disable-spdy \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_enable messages) \
		$(use_enable messages postprocessor) \
		$(use_enable ssl https) \
		$(use_with ssl gnutls) \
		$(use_enable static-libs static)
}

src_install() {
	default

	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +
}
