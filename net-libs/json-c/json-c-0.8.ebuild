DESCRIPTION="a library for javascript object notation backends"
HOMEPAGE="http://oss.metaparadigm.com/json-c/"
LICENSE="MIT"

SRC_URI="http://oss.metaparadigm.com/${PN}/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
}
