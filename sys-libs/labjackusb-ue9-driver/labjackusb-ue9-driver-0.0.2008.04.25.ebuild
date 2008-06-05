inherit linux-mod toolchain-funcs

DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
SRC_URI="http://labjack.com/files/Linux_C_NativeUSB_U3UE9.zip"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ~amd64"

S="${WORKDIR}/Linux_C_NativeUSB_U3UE9"

DEPEND="
	virtual/os-headers
	app-arch/unzip
"
RDEPEND=""

MODULE_NAMES="labjackue9(usb/misc:${S}/Driver/UE9)"
BUILD_TARGETS="default"

CONFIG_CHECK="USB"
PARPORT_ERROR="Please make sure USB support is enabled in your kernel"

src_unpack() {
	unzip "${DISTDIR}/${A}" Linux_C_NativeUSB_U3UE9/{Driver/UE9/\*,README}
}

src_install() {
	linux-mod_src_install
	dodoc README
}
