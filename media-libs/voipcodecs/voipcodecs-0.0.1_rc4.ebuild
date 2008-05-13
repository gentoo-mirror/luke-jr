DESCRIPTION="A set of commonly used, unencumbered, codecs for VoIP"
HOMEPAGE="http://freeswitch.org/"
LICENSE="GPL-2"

FS_P='freeswitch-1.0.rc4'
SRC_URI="http://files.freeswitch.org/${FS_P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc mmx sse fixed-point"

DEPEND=""
RDEPEND="${DEPEND}"

subS="${FS_P}/libs/${PN}"
S="${WORKDIR}/${subS}"

src_unpack() {
	tar -xzf "${DISTDIR}/${A}" "${subS}"
}

src_compile() {
	econf \
		$(use_enable doc) \
		$(use_enable mmx) \
		$(use_enable sse) \
		$(use_enable fixed-point) \
	|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	insinto /usr/lib/pkgconfig
	newins "${FILESDIR}/${P}.pc" "${PN}.pc"
}

# TODO: tests
