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
		--enable-dso \
	|| die "configure failed"
	emake all shared || die "emake failed"
}

src_install() {
	dobin dnsget ex-rdns rblcheck
	dolib.a libudns.a
	dolib.so libudns*.so*
	doman *.1
	dodoc COPYING.LGPL NEWS NOTES TODO
	insinto /usr/include
	doins udns.h
}
