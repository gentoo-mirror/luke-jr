MyP="${P/_p/r}"
DESCRIPTION="Prince is a computer program that converts XML and HTML into PDF documents."
HOMEPAGE="http://www.princexml.com/"
SRC_URI="http://www.princexml.com/download/${MyP}-linux.tar.gz"
LICENSE="Prince-EULA"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MyP}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/destdir.patch"
}

src_install() {
	DESTDIR="${D}" ./install.sh <<<'/usr'
}
