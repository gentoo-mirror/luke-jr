# Copyright 2019 Luke Dashjr

EAPI=7

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="https://foo.example.org/"
SRC_URI="https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/${PN}/source-archive.zip -> ${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

inherit cmake-utils

RDEPEND="dev-libs/libcaldav"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}/src"

src_prepare() {
	perl -ple '
		if (m/include_directories\(/) {
			print;
			$_ = "'$(echo /usr/include/libcaldav-*)'"
		} elsif (m/target_link_libraries\(kcal_caldav\b/) {
			print;
			$_ = "caldav"
		} elsif (m/kcaldav_caldav_lib/) {
			undef $_
		}
	' -i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=( -D KCALDAV_VERSION="${PV}" )
	cmake-utils_src_configure
}
