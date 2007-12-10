inherit qt4

DESCRIPTION="labels, business cards and media covers easy creation and printing."
HOMEPAGE="http://qlabels.p34.net"
SRC_URI="http://qlabels.p34.net/files/${P/-/_}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	eqmake4
	emake
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}

