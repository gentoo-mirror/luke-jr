DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
SRC_URI=""
SLOT="0"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ~amd64"
SLOT="0"

DEPEND=""
RDEPEND=""

src_install() {
	cd "${FILESDIR}"
	insinto '/etc/udev/rules.d'
	doins '70-labjackusb.rules'
}
