EAPI='2'

inherit linux-mod toolchain-funcs

DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
MyCPN="Linux_C_NativeUSB_U3UE9"
MyPV="${PV/0.0.}"
MyPV="${MyPV//./-}"
SRC_URI="
	http://luke.dashjr.org/mirror/labjack/${MyCPN}_${MyPV}.zip
"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ~amd64"
SLOT="0"

S="${WORKDIR}/${MyCPN}"

DEPEND="
	virtual/os-headers
	app-arch/unzip
"
RDEPEND="
	sys-libs/labjackusb-udev-rules
"

MODULE_NAMES="labjacku3(usb/misc:${S}/Driver/U3)"
BUILD_TARGETS="default"

CONFIG_CHECK="USB"
PARPORT_ERROR="Please make sure USB support is enabled in your kernel"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="$BUILD_PARAMS KDIR=${KV_DIR}"
}

src_unpack() {
	unzip "${DISTDIR}/${A}" "${MyCPN}"/{Driver/U3/\*,README}
}

src_install() {
	linux-mod_src_install
	dodoc README
}
