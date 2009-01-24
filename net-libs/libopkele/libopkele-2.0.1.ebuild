EAPI=2

DESCRIPTION="a c++ implementation of an OpenID decentralized identity system"
HOMEPAGE="http://kin.klever.net/libopkele/"
SRC_URI="http://kin.klever.net/dist/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples konforka"

DEPEND="
	dev-libs/boost
	dev-libs/openssl
	net-misc/curl
	dev-libs/libpcre
	dev-libs/expat
	app-text/htmltidy
	
	doc? (
		app-doc/doxygen
	)
	
	examples? (
		|| ( sys-libs/e2fsprogs-libs sys-fs/e2fsprogs )
		dev-db/sqlite:3
		net-libs/kingate
	)
	
	konforka? (
		dev-libs/konforka
	)
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	dev-util/pkgconfig
"

pkg_setup() {
	use examples &&
		die 'USE=examples not implemented'
}

src_prepare() {
	cd "${S}"
	sed -i 's:tidy.h tidy/tidy.h:tidy.h:' configure
}

src_configure() {
	econf \
		$(use_enable konforka) \
		$(use_enable doc doxygen) \
		$(use_enable debug) \
		--with-tr1-memory=boost \
	 || die 'econf failed'
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS
}
