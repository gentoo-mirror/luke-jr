# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepimlibs"
KMMODULE="kdepimlibs"
KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
SQL_REQUIRED="always"
inherit kde4-base

COMMIT="9d002cef7ba36b6617935f33934badc39867d9eb"

DESCRIPTION="Common library for KDE PIM apps"
SRC_URI="https://github.com/luke-jr/kdepimlibs/archive/${COMMIT}.tar.gz -> kdepimlibs-${PV}.tar.gz"

KEYWORDS="amd64 ~arm x86"
LICENSE="LGPL-2.1"
IUSE="debug ldap"

# some tests fail
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.8.0
	dev-libs/boost:=
	dev-libs/cyrus-sasl
	dev-libs/libgpg-error
	dev-libs/libical:=
	dev-libs/qjson
	media-libs/phonon[qt4]
	x11-misc/shared-mime-info
	ldap? ( net-nds/openldap )
"
# boost is not linked to, but headers which include it are installed
# bug #418071
RDEPEND="${DEPEND}
	kde-frameworks/kio
"

S="${WORKDIR}/kdepimlibs-${COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
		-DBUILD_doc=$(usex handbook)
		$(cmake-utils_use_find_package ldap Ldap)
		-DCMAKE_DISABLE_FIND_PACKAGE_Prison=ON
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# Collides with net-im/choqok
	rm "${ED}"usr/share/apps/cmake/modules/FindQtOAuth.cmake || die

	# kdelibs4 expects kioexec in PATH
	# This is needed at least for KMail opening attachments
	dosym ../lib/libexec/kf5/kioexec /usr/bin/kioexec
}
