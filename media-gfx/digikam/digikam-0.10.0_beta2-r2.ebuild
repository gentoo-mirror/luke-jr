DESCRIPTION="A digital photo management application for KDE."
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
RDEPEND="${DEPEND}"
IUSE="addressbook debug geolocation"
IUSE="$IUSE kdeprefix"
for L in ar be bg ca da de el es et eu fa fi fr ga gl he hi is ja km ko lb lt lv nds ne nl nn pa pl pt pt_BR ro ru se sk sv th tr uk vi zh_CN; do
	IUSE="$IUSE linguas_$L"
done
SLOT="4.1"

KEYWORDS="~amd64 ~x86"

# it have dynamic search for deps, so if they are in system it
# uses them otherwise does not, so any iuse are useless
DEPEND="
	dev-db/sqlite:3
	kde-base/kdebase-data:${SLOT}
	kde-base/libkdcraw:${SLOT}
	kde-base/libkexiv2:${SLOT}
	kde-base/libkipi:${SLOT}
	geolocation? (
		kde-base/marble:${SLOT}[kde]
	)
	addressbook? (
		kde-base/kdepimlibs:${SLOT}
	)
	kde-base/solid:${SLOT}
	!kdeprefix? ( !media-gfx/digikam:0 )
	>=media-libs/jasper-1.701.0
	media-libs/jpeg
	>=media-libs/lcms-1.17
	>=media-libs/libgphoto2-2.4.1-r1
	>=media-libs/libpng-1.2.26-r1
	>=media-libs/tiff-3.8.2-r3
	sys-devel/gettext
	x11-libs/qt-core[qt3support]
	x11-libs/qt-sql[sqlite]"
#liblensfun when added should be also optional dep.
RDEPEND="${DEPEND}"

src_unpack() {
	die "Don't use this, it's just a stub for my local system"
}
