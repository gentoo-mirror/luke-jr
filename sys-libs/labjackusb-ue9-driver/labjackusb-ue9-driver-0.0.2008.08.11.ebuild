EAPI='2'

inherit linux-mod toolchain-funcs

DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
MyCPN="Linux_C_NativeUSB_U3UE9"
MyPV="${PV/0.0.}"
MyPV="${MyPV//./-}"
SRC_URI="http://labjack.com/files/${MyCPN}.zip -> ${MyCPN}_${MyPV}.zip"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ~amd64"

S="${WORKDIR}/${MyCPN}"

DEPEND="
	virtual/os-headers
	app-arch/unzip
"
RDEPEND="
	sys-libs/labjackusb-udev-rules
"

MODULE_NAMES="labjackue9(usb/misc:${S}/Driver/UE9)"
BUILD_TARGETS="default"

CONFIG_CHECK="USB"
PARPORT_ERROR="Please make sure USB support is enabled in your kernel"

src_unpack() {
	unzip "${DISTDIR}/${A}" "${MyCPN}"/{Driver/UE9/\*,README}
}

src_install() {
	linux-mod_src_install
	dodoc README
}
