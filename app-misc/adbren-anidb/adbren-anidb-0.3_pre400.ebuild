inherit eutils

DESCRIPTION="AniDB Renamer"
MyPN="${PN/-anidb/}"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}"
SRC_URI="http://luke.dashjr.org/pub/${P/0.3_pre/r}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	!app-misc/adbren
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	dev-perl/AniDB
	dev-lang/perl"

S="${WORKDIR}/${MyPN}"

MyPL='adbren.pl'

src_install() {
	exeinto "/usr/bin"
	doexe "${MyPL}"
}
