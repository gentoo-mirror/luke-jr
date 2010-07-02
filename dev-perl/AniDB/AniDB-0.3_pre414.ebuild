inherit perl-module

DESCRIPTION="Perl clients for AniDB"
MyPN="${PN}-perl"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}"
SRC_URI="http://luke.dashjr.org/pub/${P/0.3_pre/r}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	virtual/perl-IO
	dev-perl/Digest-MD4
	virtual/perl-File-Spec
	dev-perl/Log-Log4perl
	dev-perl/File-HomeDir
	dev-lang/perl"

S="${WORKDIR}/${MyPN}"
