inherit eutils

DESCRIPTION="AniDB Renamer"
SRC_URI="${P}.pl"
HOMEPAGE="${SRC_URI}"
RESTRICT="fetch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	virtual/perl-IO
	dev-perl/Digest-MD4
	virtual/perl-File-Spec
	dev-lang/perl"

S="${WORKDIR}"

src_unpack() {
	cd "${S}"
	cp "${DISTDIR}/${A}" ./adbren.pl
	epatch "${FILESDIR}/adbren-3-argvfile.patch"
	epatch "${FILESDIR}/adbren-3-dotnet.patch"
}

src_install() {
	exeinto "/usr/bin"
	doexe "adbren.pl"
}
