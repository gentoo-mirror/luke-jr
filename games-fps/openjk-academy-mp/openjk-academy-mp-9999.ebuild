# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit cmake-utils git-r3 wrapper

DESCRIPTION="Community-maintained Jedi Academy, multiplayer version"
HOMEPAGE="https://github.com/JACoders/OpenJK"
LICENSE="GPL-2"

SRC_URI=""
EGIT_REPO_URI="https://github.com/JACoders/OpenJK.git"
SLOT="0"
KEYWORDS=""

IUSE="dedicated opengl server test"

REQUIRED_USE="
	|| ( dedicated opengl )
	dedicated? ( server )
"
DEPEND="
	opengl? (
		media-libs/libjpeg-turbo
		media-libs/libpng
		virtual/opengl
		media-libs/libsdl2
	)
	sys-libs/zlib
	test? ( dev-libs/boost )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/opt"
		-DBuildJK2SPEngine=OFF
		-DBuildJK2SPGame=OFF
		-DBuildJK2SPRdVanilla=OFF
		-DBuildMPCGame=$(usex opengl)
		-DBuildMPDed=$(usex dedicated)
		-DBuildMPEngine=$(usex opengl)
		-DBuildMPGame=$(usex server)
		-DBuildMPRdVanilla=$(usex opengl)
		-DBuildMPUI=$(usex opengl)
		-DBuildSPEngine=OFF
		-DBuildSPGame=OFF
		-DBuildSPRdVanilla=OFF
		-DBuildTests=$(usex test)
	)

	cmake-utils_src_configure
}

GAMEDIR="/opt/JediAcademy"

openjk_make_wrapper() {
	local binname="$1"
	local fullbinname=$( cd "${D}/${GAMEDIR}" && echo ${binname}.* )
	make_wrapper "${binname}" "${GAMEDIR}/${fullbinname}"
}

src_install() {
	cmake-utils_src_install
	use opengl && openjk_make_wrapper openjk
	use dedicated && openjk_make_wrapper openjkded
	cd "${ED}/opt"
	use test && mv UnitTests JediAcademy/UnitTests-MP
}

pkg_postinst() {
	einfo "Copy data files into ${GAMEDIR}/base"
}
