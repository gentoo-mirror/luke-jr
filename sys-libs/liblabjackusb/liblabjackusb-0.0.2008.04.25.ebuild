DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
SRC_URI="http://labjack.com/files/Linux_C_NativeUSB_U3UE9.zip"
SLOT="0"

LICENSE="X11"
IUSE=""
KEYWORDS="x86 ~amd64"

S="${WORKDIR}/Linux_C_NativeUSB_U3UE9/liblabjackusb"

DEPEND="
	app-arch/unzip
"
RDEPEND=""

src_unpack() {
	unzip "${DISTDIR}/${A}" Linux_C_NativeUSB_U3UE9/{liblabjackusb/\*,README}
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
