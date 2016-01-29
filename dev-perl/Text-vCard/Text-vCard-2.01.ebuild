EAPI=5

inherit perl-module

DESCRIPTION="a package to parse, edit and create vCards"
HOMEPAGE="http://search.cpan.org/~llap/Text-vCard-2.01/"
SRC_URI="mirror://cpan/authors/id/L/LL/LLAP/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	>=dev-perl/File-Slurp-9999.04
	>=virtual/perl-MIME-Base64-3.07
	>=virtual/perl-Test-Simple-0.1
	>=dev-perl/Text-vFile-asData-0.05
	dev-lang/perl"
