inherit perl-module

DESCRIPTION="Perl clients for AniDB"
MyPN="${PN}-perl"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}"
SvnRev="${PV/*_pre/}"
SRC_URI="http://dev.anidb.info/websvn/dl.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}%2F&rev=${SvnRev}&.tgz"

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
