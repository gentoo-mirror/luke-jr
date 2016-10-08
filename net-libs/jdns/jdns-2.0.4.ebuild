# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib multilib qmake-utils

DESCRIPTION="A simple DNS implementation that can perform multicast DNS queries and advertising"
HOMEPAGE="http://delta.affinix.com/${PN}/"
LICENSE="MIT"

SRC_URI="http://delta.affinix.com/download/${P}.tar.bz2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5 tools"

DEPEND="
	qt4? ( dev-qt/qtcore:4[${MULTILIB_USEDEP}] )
	qt5? ( dev-qt/qtcore:5[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"
REQUIRED_USE="tools? ( || ( qt4 qt5 ) ) ?? ( qt4 qt5 )"

DOCS=( README.md )

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_JDNS_TOOL="$(usex tools)"
	)
	if use qt4 || use qt5; then
		mycmakeargs+=(
			-DBUILD_QJDNS=ON
			-DQT4_BUILD="$(usex qt4)"
		)
	else
		mycmakeargs+=( -DBUILD_QJDNS=OFF )
	fi
	cmake-utils_src_configure
}
