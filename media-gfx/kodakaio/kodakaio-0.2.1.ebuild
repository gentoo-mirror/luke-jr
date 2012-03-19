# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sane-backends/sane-backends-1.0.22-r2.ebuild,v 1.3 2012/01/21 22:52:52 phosphan Exp $

EAPI="4"

inherit eutils flag-o-matic multilib

IUSE="avahi usb gphoto2 ipv6"

DESCRIPTION="Kodak AIO SANE backend"
HOMEPAGE="http://sourceforge.net/projects/cupsdriverkodak/"

RDEPEND="
	avahi? ( >=net-dns/avahi-0.6.24 )
	usb? ( virtual/libusb:0 )
	gphoto2? (
		media-libs/libgphoto2
		virtual/jpeg
	)
"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	dev-util/pkgconfig"

RDEPEND="${RDEPEND}
	!<sys-fs/udev-114"

myP="${PN}-${PV/./}"
SRC_URI="mirror://sourceforge/cupsdriverkodak/Scanning%20-%20sane%20backend/${myP}.tar.gz"
SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

S="${WORKDIR}/${myP}/sane-backends-${myP}"

pkg_setup() {
	enewgroup scanner
}

src_configure() {
	append-flags -fno-strict-aliasing

	local BACKENDS="kodakaio"

	local myconf=$(use_enable usb libusb)
	myconf="${myconf} --disable-latex"
	SANEI_JPEG="sanei_jpeg.o" SANEI_JPEG_LO="sanei_jpeg.lo" \
	BACKENDS="${BACKENDS}" econf \
		$(use_with gphoto2) \
		$(use_enable ipv6) \
		$(use_enable avahi) \
		${myconf}
}

src_compile() {
	emake VARTEXFONTS="${T}/fonts" || die

	if use usb; then
		cd tools/hotplug
		grep -v '^$' libsane.usermap > libsane.usermap.new
		mv libsane.usermap.new libsane.usermap
	fi
}

src_install () {
	insinto /etc/sane.d
	doins backend/kodakaio.conf
	
	insinto /usr/lib/sane
	doins backend/.libs/libsane-kodakaio.so{,.1{,.0.22}}
	
	doman doc/sane-kodakaio.5
	
	dodoc ../ReleaseNotes-kodakaio-02.1
}
