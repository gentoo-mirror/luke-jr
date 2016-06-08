# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils eutils git-r3

DESCRIPTION="Community-maintained Jedi Academy, story version"
HOMEPAGE="https://github.com/JACoders/OpenJK"
LICENSE="GPL-2"

SRC_URI=""
EGIT_REPO_URI="https://github.com/JACoders/OpenJK.git"
SLOT="0"
KEYWORDS=""

IUSE="test"

DEPEND="
	media-libs/libjpeg-turbo
	media-libs/libpng
	sys-libs/zlib
	virtual/opengl
	media-libs/libsdl2
	test? ( dev-libs/boost )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/opt"
		-DBuildJK2SPEngine=OFF
		-DBuildJK2SPGame=OFF
		-DBuildJK2SPRdVanilla=OFF
		-DBuildMPCGame=OFF
		-DBuildMPDed=OFF
		-DBuildMPEngine=OFF
		-DBuildMPGame=OFF
		-DBuildMPRdVanilla=OFF
		-DBuildMPUI=OFF
		-DBuildSPEngine=ON
		-DBuildSPGame=ON
		-DBuildSPRdVanilla=ON
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
	openjk_make_wrapper openjk_sp
	keepdir "${GAMEDIR}/base"
	cd "${ED}/opt"
	use test && mv UnitTests JediAcademy/UnitTests-SP
}

pkg_postinst() {
	einfo "Copy data files into ${GAMEDIR}/base"
}
