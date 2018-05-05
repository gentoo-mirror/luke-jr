EAPI=6

DIST_AUTHOR="CWEST"
DIST_VERSION="${PV}"

inherit perl-module

DESCRIPTION="Support IMAP schemas with URI"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	dev-perl/URI
	dev-lang/perl"
