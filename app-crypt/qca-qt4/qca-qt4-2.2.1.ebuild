# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake qmake-utils

MyPN="qca"
DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="https://userbase.kde.org/QCA"
SRC_URI="mirror://kde/stable/${MyPN}/${PV}/${MyPN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

IUSE="botan debug doc examples gcrypt gpg libressl logger nss pkcs11 sasl softstore +ssl test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MyPN}-${PV}"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-qt/qtcore:4
	botan? ( dev-libs/botan:= )
	gcrypt? ( dev-libs/libgcrypt:= )
	gpg? ( app-crypt/gnupg )
	nss? ( dev-libs/nss )
	pkcs11? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		dev-libs/pkcs11-helper
	)
	sasl? ( dev-libs/cyrus-sasl:2 )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtnetwork:4
		dev-qt/qttest:4
	)
"

PATCHES=( "${FILESDIR}/${MyPN}-disable-pgp-test.patch" )

qca_plugin_use() {
	echo -DWITH_${2:-$1}_PLUGIN=$(usex "$1")
}

src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=ON
		-DQCA_FEATURE_INSTALL_DIR="${EPREFIX}/usr/share/qt4/mkspecs/features"
		-DQCA_PLUGINS_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/qt4/plugins"
		$(qca_plugin_use botan)
		$(qca_plugin_use gcrypt)
		$(qca_plugin_use gpg gnupg)
		$(qca_plugin_use logger)
		$(qca_plugin_use nss)
		$(qca_plugin_use pkcs11)
		$(qca_plugin_use sasl cyrus-sasl)
		$(qca_plugin_use softstore)
		$(qca_plugin_use ssl ossl)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	local -x QCA_PLUGIN_PATH="${BUILD_DIR}/lib/qca"
	cmake_src_test
}

src_install() {
	cmake_src_install

	if use doc; then
		pushd "${BUILD_DIR}" >/dev/null || die
		doxygen Doxyfile || die
		dodoc -r apidocs/html
		popd >/dev/null || die
	fi

	if use examples; then
		dodoc -r "${S}"/examples
	fi
}
