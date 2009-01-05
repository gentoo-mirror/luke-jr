EAPI='2'

inherit multilib python

DESCRIPTION="Python bindings for LabJack devices"
HOMEPAGE="http://www.labjack.com"
MyPN="LabJackPython"
LICENSE="X11"

SRC_URI="http://www.labjack.com/files/${MyPN}.zip -> ${P}.zip"

SLOT="0"
KEYWORDS="~x86"

IUSE="usb"

DEPEND="
	app-arch/unzip
	dev-lang/python
	"
RDEPEND="
	dev-lang/python
	usb? (
		>=sys-libs/liblabjackusb-1.10
		|| (
			sys-libs/labjackusb-ue9-driver
			sys-libs/labjackusb-u3-driver
		)
	)
	|| (
		dev-python/ctypes
		>=dev-lang/python-2.5
	)
	"

S="${WORKDIR}/${MyPN}"

pkg_setup() {
	python_version
	TGT="/usr/$(get_libdir)/python${PYVER}/site-packages/"
}

src_compile() {
	chmod +x Examples/*.py
}

src_install() {
	dodoc README.txt
	for d in Documentation EI1050_Sample_App Examples; do
		docinto $d
		dodoc $d/*
	done
	
	insinto "${TGT}"
	doins src/${MyPN}.py
}

pkg_postinst() {
	if has_version ">=dev-lang/python-2.3"; then
		python${PYVER}    -m py_compile "${ROOT}${TGT}/${MyPN}.py"
		python${PYVER} -O -m py_compile "${ROOT}${TGT}/${MyPN}.py"
	fi
}

pkg_postrm() {
	local x
	for x in c o; do
		local PYO="${ROOT}${TGT}/${MyPN}.py$x"
		[ -e "$PYO" ] && rm -v "$PYO"
	done
}
