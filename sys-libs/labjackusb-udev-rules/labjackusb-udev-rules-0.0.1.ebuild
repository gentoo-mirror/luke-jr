DESCRIPTION=""
HOMEPAGE="http://labjack.com/"
SRC_URI=""
SLOT="0"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ~amd64"

DEPEND=""
RDEPEND=""

src_install() {
	insinto '/usr/udev/rules.d'
	doins '70-labjackusb.rules'
}
