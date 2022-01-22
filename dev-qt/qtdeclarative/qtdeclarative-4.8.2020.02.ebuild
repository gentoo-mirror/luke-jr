# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV='4.8.7'
QT4_DEBIAN_PATCHES_COMMIT='df517fcfe4ee9430cff23a180be42ae5ebe867d5'
inherit qt4-build-multilib

DESCRIPTION="The Declarative module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+accessibility qt3support webkit"

DEPEND="
	>=dev-qt/qtcore-4.8.2020.02[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-${MY_PV}[accessibility=,aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	>=dev-qt/qtopengl-${MY_PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	>=dev-qt/qtscript-${MY_PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	>=dev-qt/qtsql-${MY_PV}[aqua=,debug=,qt3support=,${MULTILIB_USEDEP}]
	>=dev-qt/qtsvg-${MY_PV}[accessibility=,aqua=,debug=,${MULTILIB_USEDEP}]
	>=dev-qt/qtxmlpatterns-${MY_PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	qt3support? ( >=dev-qt/qt3support-${MY_PV}[accessibility=,aqua=,debug=,${MULTILIB_USEDEP}] )
	webkit? ( >=dev-qt/qtwebkit-${MY_PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/declarative
	src/imports
	src/plugins/qmltooling
	tools/qml
	tools/qmlplugindump"

QCONFIG_ADD="declarative"
QCONFIG_DEFINE="QT_DECLARATIVE"

pkg_setup() {
	use webkit && QT4_TARGET_DIRECTORIES+="
		src/3rdparty/webkit/Source/WebKit/qt/declarative"
}

multilib_src_configure() {
	local myconf=(
		-declarative -no-gtkstyle
		$(qt_use accessibility)
		$(qt_use qt3support)
		$(qt_use webkit)
	)
	qt4_multilib_src_configure
}
