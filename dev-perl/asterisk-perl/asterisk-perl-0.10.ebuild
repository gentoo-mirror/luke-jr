EAPI=5

inherit perl-module

DESCRIPTION="asterisk-perl is a collection of perl modules to be used with the Asterisk PBX"
HOMEPAGE="http://asterisk.gnuinter.net/"
SRC_URI="http://asterisk.gnuinter.net/files/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	virtual/perl-Digest-MD5
	dev-lang/perl"
