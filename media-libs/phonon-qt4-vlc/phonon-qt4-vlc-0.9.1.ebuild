# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="phonon-backend-vlc"
MY_P="${MY_PN}-${PV}"

SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_P}.tar.xz"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd"
S="${WORKDIR}/${MY_P}"

inherit cmake-utils multibuild

DESCRIPTION="Phonon VLC backend"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug"

RDEPEND="
	|| (
		>=media-libs/phonon-qt4-4.9.0
		>=media-libs/phonon-4.9.0[qt4]
	)
	>=media-video/vlc-2.0.1:=[dbus,ogg,vorbis]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS )

pkg_setup() {
	MULTIBUILD_VARIANTS=( qt4 )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DPHONON_BUILD_PHONON4QT5=OFF
		)
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
