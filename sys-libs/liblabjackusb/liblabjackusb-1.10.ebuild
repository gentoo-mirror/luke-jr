EAPI='2'

DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
MyCPN="Linux_C_NativeUSB_U3UE9"
MyPV="2008-08-11"  # Not actually important, but the lib is bundled with the drivers...
SRC_URI="http://labjack.com/files/${MyCPN}.zip -> ${MyCPN}_${MyPV}.zip"
SLOT="0"

LICENSE="X11"
IUSE=""
KEYWORDS="x86 ~amd64"

S="${WORKDIR}/${MyCPN}/liblabjackusb"

DEPEND="
	app-arch/unzip
"
RDEPEND=""

src_unpack() {
	unzip "${DISTDIR}/${A}" "${MyCPN}"/{liblabjackusb/\*,README}
}

src_compile() {
	emake || die 'emake failed'
}

src_install() {
	insinto '/usr/include'
	doins 'labjackusb.h'
	dolib.so 'liblabjackusb.so' || die 'failed to install lib'
	dodoc ../README
}
