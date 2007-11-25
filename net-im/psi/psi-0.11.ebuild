# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib qt4

DESCRIPTION="QT 4.x Jabber Client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.bz2"
RESTRICT="mirror"

IUSE="crypt doc kernel_linux spell ssl xscreensaver"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="$(qt4_min_version 4.2.3)
	=app-crypt/qca-2*
	media-libs/libpng
	spell? ( app-text/aspell )
	ssl? ( dev-libs/openssl )
	xscreensaver? ( x11-libs/libXScrnSaver )"

RDEPEND="${DEPEND}
	crypt? ( >=app-crypt/qca-gnupg-0.1_p20070904 )
	ssl? ( >=app-crypt/qca-ossl-0.1_p20070904 )"

DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if ! built_with_use x11-libs/qt qt3support ; then
		eerror
		eerror "In order to compile Psi, you will need to recompile"
		eerror "qt4 with 'qt3support' USE flag enabled."
		eerror
		die "Recompile qt4 with USE=\"qt3support\""
	fi
}

src_compile() {
	# growl is mac osx extension only - maybe someday we will want this
	local myconf="--disable-growl --disable-bundled-qca"
	use kernel_linux || myconf="${myconf} --disable-dnotify"
	use ssl || myconf="${myconf} --disable-openssl"
	use spell || myconf="${myconf} --disable-aspell"
	use xscreensaver || myconf="${myconf} --disable-xss"

	QTDIR=/usr/$(get_libdir) ./configure \
		--prefix=/usr ${myconf} \
		|| die "configure failed"

	eqmake4 ${PN}.pro
	emake || die "emake failed"

	if use doc; then
		cd doc
		make api_public || die "make api_public failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"

	# this way the docs will be installed in the standard gentoo dir
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	if use doc; then
		cd doc
		dohtml -r api || die "dohtml failed"
	fi
}
