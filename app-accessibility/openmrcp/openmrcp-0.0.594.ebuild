DESCRIPTION=""
HOMEPAGE="http://openmrcp.org/"
LICENSE="MPL-1.1"

FS_P='freeswitch-1.0.0'
SRC_URI="http://files.freeswitch.org/${FS_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cepstral"

DEPEND="
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	cepstral? ( virtual/cepstral-voice )
	net-libs/sofia-sip
"
RDEPEND="${DEPEND}"

subS="${FS_P}/libs/${PN}"
S="${WORKDIR}/${subS}"

src_unpack() {
	tar -xzf "${DISTDIR}/${A}" "${subS}"
}

src_compile() {
	econf \
		--with-sofia-sip=/usr \
	|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
}
