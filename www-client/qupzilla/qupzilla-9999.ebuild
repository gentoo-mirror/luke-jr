# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/qupzilla/qupzilla-1.3.1.ebuild,v 1.3 2012/08/16 10:01:11 johu Exp $

EAPI=4

inherit multilib qt4-r2 git-2

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"
EGIT_REPO_URI="git://github.com/QupZilla/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="dbus debug kde"

DEPEND="
	>=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qtscript-4.7:4
	>=dev-qt/qtsql-4.7:4
	>=dev-qt/qtwebkit-4.7:4
	dbus? ( >=dev-qt/qtdbus-4.7:4 )
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGELOG FAQ"

src_configure() {
	export QUPZILLA_PREFIX=${EPREFIX}/usr/
	export USE_LIBPATH=${QUPZILLA_PREFIX}$(get_libdir)
	export DISABLE_DBUS=$(use dbus && echo false || echo true)
	export KDE=$(use kde && echo true || echo false)

	eqmake4
}
