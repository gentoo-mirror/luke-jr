EAPI=2

inherit qt4 subversion

DESCRIPTION="a GPS navigation application for the Nokia N800/N810 Internet Tablets developed using the Qt application framework"
HOMEPAGE="http://${PN}.garage.maemo.org/"
LICENSE="GPL-2"

ESVN_REPO_URI="https://garage.maemo.org/svn/${PN}/trunk/${PN}"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +mapitnotes"

DEPEND="${DEPEND}"'
	>=x11-libs/qt-core-4.4
	x11-libs/qt-sql:4
	x11-libs/qt-gui:4
	sci-geosciences/gpsd
'
RDEPEND="${RDEPEND} ${DEPEND}"'
'
DEPEND="${DEPEND} "'
	doc? ( app-doc/doxygen )
'

S="${WORKDIR}/${PN}"

src_configure() {
	local confopts='--desktop'
	use doc &&
		confopts="$confopts --doxygen"
	use mapitnotes &&
		confopts="$confopts --enablemapitnotes"
	./configure $confopts
	eqmake4 || die 'eqmake4 failed'
}

src_compile() {
	emake || die 'emake failed'
}
