# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_PV='4.8.7'
inherit qt4-build-multilib

DESCRIPTION="The Qt3Support module for the Qt toolkit"

SRC_URI="${SRC_URI}
	https://salsa.debian.org/qt-kde-team/qt/qt4-x11/-/archive/df517fcfe4ee9430cff23a180be42ae5ebe867d5/qt4-x11-master.tar.bz2?path=debian/patches -> qt4-x11-debian-patches-20200204.tar.bz2
"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+accessibility"

DEPEND="
	>=dev-qt/qtcore-${MY_PV}[aqua=,debug=,qt3support,${MULTILIB_USEDEP}]
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

src_prepare() {
	local DEBIAN_PATCHES="$(echo "${WORKDIR}/qt4-x11-"*"-debian-patches/debian/patches/")" p
	while read -u3 p; do
		p="${p/\#*/}"  # strip comment
		[ -n "${p}" ] || continue
		case "${p}" in
		07_trust_dpkg-arch_over_uname-m.diff | \
		94_armv6_uname_entry.diff )
			continue
			;;
		esac
		epatch "${DEBIAN_PATCHES}/${p}"
	done 3<"${DEBIAN_PATCHES}/series"

	qt4-build-multilib_src_prepare
}
