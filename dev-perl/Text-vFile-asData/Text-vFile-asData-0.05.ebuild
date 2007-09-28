inherit perl-module

DESCRIPTION="parse vFile formatted files into data structures"
HOMEPAGE="http://search.cpan.org/~rclamp/Text-vFile-asData-0.05/"
SRC_URI="mirror://cpan/authors/id/R/RC/RCLAMP/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-perl/Class-Accessor-Chained
	dev-lang/perl"
DEPEND="
	virtual/perl-Test-Simple
	>=dev-perl/module-build-0.26.01
	${RDEPEND}"
