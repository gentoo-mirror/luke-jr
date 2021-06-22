# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="This package contains the USB library/examples (written in C) for calling low-level U3, U6 and UE9 functions over a USB connection"
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
	virtual/libusb:1[${MULTILIB_USEDEP}]
	acct-group/uucp
"
DEPEND="
	app-arch/unzip
	${RDEPEND}
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		CFLAGS="${CFLAGS} -fPIC" \
		LIBFLAGS="${LDFLAGS} -lusb-1.0 -lc" \
		|| die 'emake failed'
}

multilib_src_install() {
	local LIBDIR="/usr/$(get_libdir)"
	dolib.so liblabjackusb.so*
	dosym liblabjackusb.so* "${LIBDIR}/liblabjackusb.so.2"
	dosym liblabjackusb.so.2 "${LIBDIR}/liblabjackusb.so"
}

multilib_src_install_all() {
	insinto '/usr/include'
	doins 'labjackusb.h'
	dodoc ../README
	insinto '/lib/udev/rules.d'
	doins '../10-labjack.rules'
	sed -i 's:admin:uucp:' "${ED}/lib/udev/rules.d/10-labjack.rules" || die
	
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r '../Examples'
	fi
}
