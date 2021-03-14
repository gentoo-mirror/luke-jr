# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EBZR_REPO_URI="lp:libdbusmenu-qt"

[[ ${PV} == 9999* ]] && inherit bzr
inherit cmake-multilib multibuild virtualx

MyPN="${PN/4/}"
DESCRIPTION="Library providing Qt 4 implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
if [[ ${PV} != 9999* ]] ; then
	MY_PV=${PV/_pre/+16.04.}
	SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${MyPN}_${MY_PV}.orig.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="
	>=dev-qt/qtcore-4.8.6:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtdbus-4.8.6:4[${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-4.8.6:4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	!!dev-libs/libdbusmenu-qt[qt4(-)]
	test? (
		>=dev-qt/qttest-4.8.6:4[${MULTILIB_USEDEP}]
	)
"

[[ ${PV} == 9999* ]] || S=${WORKDIR}/${MyPN}-${MY_PV}

DOCS=( NEWS README )

# tests fail due to missing connection to dbus
RESTRICT="test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( 4 )
}

src_prepare() {
	[[ ${PV} == 9999* ]] && bzr_src_prepare
	cmake-utils_src_prepare

	cmake_comment_add_subdirectory tools
	use test || cmake_comment_add_subdirectory tests
}

multilib_src_configure() {
	local mycmakeargs=(
		-DWITH_DOC=OFF
		-DUSE_QT${QT_MULTIBUILD_VARIANT}=ON
		-DQT_QMAKE_EXECUTABLE="/usr/$(get_libdir)/qt${QT_MULTIBUILD_VARIANT}/bin/qmake"
	)
	cmake-utils_src_configure
}

src_configure() {
	myconfigure() {
		local QT_MULTIBUILD_VARIANT=${MULTIBUILD_VARIANT}
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_configure
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_configure
		fi
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_compile
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_compile
		fi
	}

	multibuild_foreach_variant mycompile
}

src_install() {
	myinstall() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_install
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			cmake-utils_src_install
		fi
	}

	multibuild_foreach_variant myinstall
}

src_test() {
	mytest() {
		if [[ ${MULTIBUILD_VARIANT} = 4 ]] ; then
			cmake-multilib_src_test
		elif [[ ${MULTIBUILD_VARIANT} = 5 ]] ; then
			multilib_src_test
		fi
	}

	multibuild_foreach_variant mytest
}

multilib_src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests virtx cmake-utils_src_test

	BUILD_DIR=${builddir}
}
