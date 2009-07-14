EAPI='2'

inherit multilib

DESCRIPTION="This package contains the USB library/examples (written in C) for calling low-level U3, U6 and UE9 functions over a USB connection."
HOMEPAGE="http://labjack.com/"
MyCPN="Linux_C_NativeUSB"
MyPV="2009-07-08"
SRC_URI="
	http://labjack.com/files/${MyCPN}.zip -> ${P}.zip
	http://luke.dashjr.org/mirror/labjack/${P}.zip
"

LICENSE="MIT"
IUSE="examples"
KEYWORDS="~x86 ~amd64"
SLOT="0"

S="${WORKDIR}/${MyCPN}/${PN}"

RDEPEND="
	!sys-libs/labjackusb-udev-rules
	!sys-libs/labjackusb-u3-driver
	!sys-libs/labjackusb-ue9-driver
	virtual/libusb:1
"
DEPEND="
	app-arch/unzip
	${RDEPEND}
"

src_compile() {
	emake || die 'emake failed'
}

src_install() {
	local DLIB="${D}/usr/$(get_libdir)"
	mkdir -p "${DLIB}"
	einstall DESTINATION="${DLIB}" || die 'einstall failed'
	insinto '/usr/include'
	doins 'labjackusb.h'
	dodoc ../README
	insinto '/etc/udev/rules.d'
	doins '../10-labjack.rules'
	dosed 's:admin:uucp:' '/etc/udev/rules.d/10-labjack.rules'
	
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r '../Examples'
	fi
}

pkg_postinst() {
	ewarn "The new user-space driver will not work with the old U3/UE9 kernel"
	ewarn "drivers. Please ensure they are removed and unloaded."
	ewarn "Read $(echo /usr/share/doc/${PF}/README*) for details."
}
