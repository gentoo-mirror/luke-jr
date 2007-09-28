inherit perl-module

DESCRIPTION="Support IMAP schemas with URI"
HOMEPAGE="http://search.cpan.org/~cwest/URI-imap-1.01/"
SRC_URI="mirror://cpan/authors/id/C/CW/CWEST/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	dev-perl/URI
	dev-lang/perl"
