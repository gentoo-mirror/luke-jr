# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
TRINITY_MODULE_NAME="tdebase"

inherit trinity-meta

TSM_EXTRACT="tdeioslave"

DESCRIPTION="Generic Trinity KIOslaves"
KEYWORDS=
IUSE="samba ldap sasl openexr -hal +tdehw +tdeio_media"
REQUIRED_USE="tdehw? ( !hal )"

DEPEND="
	x11-libs/libXcursor
	openexr? ( >=media-libs/openexr-1.2.2-r2 )
	samba? ( net-fs/samba )
	ldap? ( net-nds/openldap )
	sasl? ( dev-libs/cyrus-sasl )
	hal? ( dev-libs/dbus-tqt
		=sys-apps/hal-0.5* )"

RDEPEND="${DEPEND}"
# CHECKME: optional dependencies
#DEPEND="
#	>=dev-libs/cyrus-sasl-2
#	hal? ( dev-libs/dbus-qt3-old =sys-apps/hal-0.5* )"
#	x11-apps/xhost
RDEPEND="${DEPEND}
	virtual/ssh
	tdeio_media? ( trinity-base/tdeeject:${SLOT} )
"

src_configure() {
	if ! use tdeio_media; then
		sed '/media/d' -i tdeioslave/CMakeLists.txt || die
	fi

	mycmakeargs=(
		-DWITH_XCURSOR=ON
		-DWITH_SAMBA="$(usex samba)"
		-DWITH_LDAP="$(usex ldap)"
		-DWITH_SASL="$(usex sasl)"
		-DWITH_OPENEXR="$(usex openexr)"
		-DWITH_HAL="$(usex hal)"
		-DWITH_TDEHWLIB="$(usex tdehw)"
	)

	trinity-meta_src_configure
}
