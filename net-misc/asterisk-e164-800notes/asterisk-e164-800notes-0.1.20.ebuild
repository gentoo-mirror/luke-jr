DESCRIPTION="Asterisk AGI script to search and append an IMAP vCard addressbook with CallerID"
HOMEPAGE="http://luke.dashjr.org/programs/AGI/"
MyP="${P/asterisk-/}"
SRC_URI="http://luke.dashjr.org/programs/AGI/${MyP}.tbz2"

LICENSE="Luke-Jr"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	dev-perl/asterisk-perl
	dev-perl/libwww-perl
	dev-lang/perl"

S="${WORKDIR}/${MyP}"

src_install() {
	exeinto /var/lib/asterisk/agi-bin/
	doexe "e164-800notes.pl"
}
