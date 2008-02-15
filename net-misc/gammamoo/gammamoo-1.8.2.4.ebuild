inherit eutils

MyPV="1.8.2g4"
MyP="${PN}-${MyPV}"

DESCRIPTION="a modern MOO server, based on LambdaMOO"
HOMEPAGE="http://luke.dashjr.org/programs/${PN}/"
SRC_URI="http://luke.dashjr.org/programs/${PN}/download/${MyP}.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~sparc"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""

S="${WORKDIR}/MOO-${MyPV}"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf || die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	newbin moo gammamoo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	newinitd "${FILESDIR}"/gammamoo.rc ${PN}
	newconfd "${FILESDIR}"/gammamoo.conf ${PN}
}
