# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MyP="phonon-${PV}"

SRC_URI="mirror://kde/stable/phonon/${PV}/${MyP}.tar.xz"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

inherit cmake-multilib multibuild qmake-utils

DESCRIPTION="KDE multimedia API"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="aqua debug designer gstreamer pulseaudio +vlc zeitgeist"

RDEPEND="
	!!dev-qt/qtphonon:4
	!!media-libs/phonon[qt4]
	dev-qt/qtcore:4[${MULTILIB_USEDEP}]
	dev-qt/qtdbus:4[${MULTILIB_USEDEP}]
	dev-qt/qtgui:4[${MULTILIB_USEDEP}]
	designer? ( dev-qt/designer:4[${MULTILIB_USEDEP}] )
	pulseaudio? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		>=media-sound/pulseaudio-0.9.21[glib,${MULTILIB_USEDEP}]
	)
	zeitgeist? ( dev-libs/libqzeitgeist )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
PDEPEND="
	aqua? ( media-libs/phonon-qt7 )
	gstreamer? ( || (
		>=media-libs/phonon-qt4-gstreamer-4.9.0
		>=media-libs/phonon-gstreamer-4.9.0[qt4]
	) )
	vlc? ( || (
		>=media-libs/phonon-qt4-vlc-0.9.0
		>=media-libs/phonon-vlc-0.9.0[qt4]
	) )
"

PATCHES=( "${FILESDIR}/${PN}-4.7.0-plugin-install.patch" )

S="${WORKDIR}/${MyP}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( qt4 )
}

multilib_src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_DESIGNER_PLUGIN=$(usex designer)
		-DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT=TRUE
		-DWITH_GLIB2=$(usex pulseaudio)
		-DWITH_PulseAudio=$(usex pulseaudio)
		$(multilib_is_native_abi && echo -DWITH_QZeitgeist=$(usex zeitgeist) || echo -DWITH_QZeitgeist=OFF)
		-DQT_QMAKE_EXECUTABLE="$(qt4_get_bindir)"/qmake
		-DPHONON_BUILD_PHONON4QT5=OFF
	)

	cmake-utils_src_configure
}

src_configure() {
	multibuild_foreach_variant cmake-multilib_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake-multilib_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-multilib_src_test
}

src_install() {
	multibuild_foreach_variant cmake-multilib_src_install
}
