inherit perl-module

DESCRIPTION="make chained accessors"
HOMEPAGE="http://search.cpan.org/~rclamp/Class-Accessor-Chained-0.01/"
SRC_URI="mirror://cpan/authors/id/R/RC/RCLAMP/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-perl/Class-Accessor
	dev-lang/perl"
DEPEND="
	virtual/perl-Test-Simple
	${RDEPEND}"
