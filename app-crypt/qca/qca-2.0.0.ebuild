# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/qca/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples"
RESTRICT="test"

DEPEND="$(qt4_min_version 4.2.0)"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use debug && ! built_with_use qt debug; then
		eerror
		eerror "You are trying to compile ${PN} package with USE=\"debug\""
		eerror "while qt4 is built without this particular flag: it will"
		eerror "not work."
		eerror
		eerror "Possible solutions to this problem are:"
		eerror "a) install package ${PN} without debug USE flag"
		eerror "b) re-emerge qt4 with debug USE flag"
		eerror
		die "can't emerge ${PN} with debug USE flag"
	fi
}

src_compile() {
	local myconf=
	if use debug; then
		myconf="--debug"
	else
		myconf="--release"
	fi

	./configure \
		--prefix=/usr \
		--qtdir=/usr \
		--includedir="/usr/include/qca2" \
		--libdir="/usr/$(get_libdir)/qca2" \
		${myconf} \
		--no-separate-debug-info \
		--disable-tests \
		|| die "configure failed"

	eqmake4 ${PN}.pro
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README TODO

	cat > "${T}"/44qca2 << EOF
LDPATH=/usr/$(get_libdir)/qca2
EOF
	doenvd "${T}"/44qca2

	if use doc; then
		dohtml "${S}"/apidocs/html/* || die "failed to install documentation"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples || die "failed to install examples"
	fi
}
