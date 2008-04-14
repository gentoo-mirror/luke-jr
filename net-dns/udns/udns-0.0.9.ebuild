DESCRIPTION=""
HOMEPAGE="http://www.corpit.ru/mjt/udns.html"
LICENSE="LGPL-2.1"

SRC_URI="http://www.corpit.ru/mjt/udns/udns_0.0.9.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	./configure \
		$(use_enable ipv6) \
	|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dobin dnsget ex-rdns rblcheck
	dolib.a libudns.a
	doman *.1
	dodoc COPYING.LGPL NEWS NOTES TODO
}
