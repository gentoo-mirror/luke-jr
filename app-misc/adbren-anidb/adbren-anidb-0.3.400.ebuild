inherit eutils

DESCRIPTION="AniDB Renamer"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2Fadbren%2F"
SRC_URI="http://luke.dashjr.org/tmp/${P}.pl"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	!app-misc/adbren
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	dev-lang/perl"

S="${WORKDIR}"

src_install() {
	exeinto "/usr/bin"
	doexe "adbren.pl"
}
