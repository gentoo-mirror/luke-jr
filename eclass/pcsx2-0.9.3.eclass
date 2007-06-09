# Author: Luke-Jr <luke@dashjr.org>
# Packages: games-emulation/pcsx2, games-emulation/ps2emu-*

inherit games

EXPORT_FUNCTIONS src_unpack src_compile src_install

DESCRIPTION="Playstation2 emulator"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="http://www.pcsx2.net/files/8022"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PROVIDE="virtual/ps2emu-${CN/\/*/}-0-9-3"
RDEPEND="
	>=x11-libs/gtk+-2.6.1
"
DEPEND="
	${RDEPEND}
	app-arch/p7zip
"

CNP="${TOPDIR:-/plugins/}${CN}"
S="${WORKDIR}${CNP}"

PCSX2PLUGINS="${WORKDIR}/i/plugins"

pcsx2_unpack() {
	7z x "${DISTDIR}/8022" "${CNP:1}" >/dev/null || die "unpack failed"
}
pcsx2-0.9.3_src_unpack() { pcsx2_unpack "$@"; }

pcsx2_prepcompile() {
	export PCSX2OPTIONS="$@"
	export PCSX2PLUGINS
	mkdir -p "${PCSX2PLUGINS}"
}

pcsx2_compile() {
	pcsx2_prepcompile "$@"
	sh build.sh all || die "build failed"
}
pcsx2-0.9.3_src_compile() { pcsx2_compile "$@"; }

pcsx2_install() {
	local MyLibDir="$(games_get_libdir)/pcsx2/"
	dodir "${MyLibDir}"
	cp -a "${PCSX2PLUGINS}" "${D}/${MyLibDir}" || die "install failed"
}
pcsx2-0.9.3_src_install() { pcsx2_install "$@"; }

