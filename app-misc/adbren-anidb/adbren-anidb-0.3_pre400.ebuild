inherit eutils

DESCRIPTION="AniDB Renamer"
MyPN="${PN/-anidb/}"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}"
SvnRev="${PV/*_pre/}"
SRC_URI="http://dev.anidb.info/websvn/dl.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}&rev=${SvnRev}&.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	!app-misc/adbren
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	dev-lang/perl"

S="${WORKDIR}/${MyPN:0:${#MyPN}-1}"	# some weird bug with WebSvn's tar generation

MyPL='adbren.pl'

src_install() {
	exeinto "/usr/bin"
	doexe "${MyPL}"
}
