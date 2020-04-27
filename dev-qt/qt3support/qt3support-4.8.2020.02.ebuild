# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_PV='4.8.7'
QT4_DEBIAN_PATCHES_COMMIT='df517fcfe4ee9430cff23a180be42ae5ebe867d5'
inherit qt4-build-multilib

DESCRIPTION="The Qt3Support module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+accessibility"

DEPEND="
	>=dev-qt/qtcore-4.8.2020.02[aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
	>=dev-qt/qtgui-${MY_PV}[accessibility=,aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
	>=dev-qt/qtsql-${MY_PV}[aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/qt3support
	src/tools/uic3
	tools/porting"

multilib_src_configure() {
	local myconf=(
		-qt3support
		$(qt_use accessibility)
	)
	qt4_multilib_src_configure
}
