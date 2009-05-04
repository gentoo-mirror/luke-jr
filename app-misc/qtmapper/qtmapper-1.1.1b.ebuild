inherit qt4

DESCRIPTION="a GPS navigation application for the Nokia N800/N810 Internet Tablets developed using the Qt application framework"
HOMEPAGE="http://${PN}.garage.maemo.org/"
LICENSE="GPL-2"

SRC_URI="https://garage.maemo.org/frs/download.php/5719/${PN}_${PV}-os2008.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND='
	>=x11-libs/qt-core-4.4
	x11-libs/qt-sql:4
	x11-libs/qt-gui:4
	sci-geosciences/gpsd
'
RDEPEND="${DEPEND} "'
'

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	
	cd "${S}"
	rm Makefile src/Makefile{,.{Debug,Release}}
	rm src/qtmapper
}

src_compile() {
	./configure --desktop
	eqmake4 || die 'eqmake4 failed'
	emake || die 'emake failed'
}
