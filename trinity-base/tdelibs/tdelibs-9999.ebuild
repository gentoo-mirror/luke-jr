# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
TRINITY_MODULE_NAME="$PN"

inherit trinity-base multilib

set-trinityver

DESCRIPTION="Trinity libraries needed by all TDE programs."
HOMEPAGE="http://www.trinitydesktop.org/"
LICENSE="GPL-2 LGPL-2"
SLOT="${TRINITY_VER}"
KEYWORDS=""
IUSE="alsa arts consolekit cryptsetup cups fam idn jpeg2k lzma networkmanager openexr +path pcre pcsc-lite pkcs11 shm spell ssl sudo svg tiff udevil udisks upower utempter xcomposite xrandr"

DEPEND="${DEPEND}
	dev-libs/dbus-1-tqt
	dev-qt/tqtinterface
	app-arch/bzip2:=
	sys-apps/file:=
	dev-libs/glib:2=
	media-libs/libjpeg-turbo:=
	dev-libs/libltdl:=
	media-libs/libpng:=
	>=dev-libs/libxslt-1.1.16:=
	>=dev-libs/libxml2-2.6.6:=
	consolekit? ( sys-auth/consolekit:= )
	cryptsetup? ( sys-fs/cryptsetup:= )
	pcre? ( >=dev-libs/libpcre-6.6:= )
	idn? ( net-dns/libidn:= )
	app-text/ghostscript-gpl
	ssl? ( >=dev-libs/openssl-0.9.7d:= )
	media-libs/fontconfig:=
	media-libs/freetype:2=
	svg? ( media-libs/libart_lgpl )
	x11-libs/libXext:=
	x11-libs/libXrender:=
	alsa? ( media-libs/alsa-lib:= )
	arts? ( trinity-base/arts:= )
	cups? ( >=net-print/cups-1.1.19:= )
	fam? ( app-admin/gamin )
	jpeg2k? ( media-libs/jasper:= )
	networkmanager? ( net-misc/networkmanager:= )
	openexr? ( >=media-libs/openexr-1.2.2-r2:= )
	pcsc-lite? ( sys-apps/pcsc-lite:= )
	pkcs11? ( dev-libs/pkcs11-helper )
	spell? ( >=app-dicts/aspell-en-6.0.0 >=app-text/aspell-0.60.5:= )
	sudo? ( app-admin/sudo )
	tiff? ( media-libs/tiff:= )
	udevil? ( sys-apps/udevil )
	udisks? ( sys-fs/udisks:2 )
	upower? ( sys-power/upower )
	utempter? ( sys-libs/libutempter )
	xcomposite? ( x11-libs/libXcomposite:= )
	xrandr? ( x11-libs/libXrandr:= )
	lzma? ( app-arch/xz-utils:= )
	sys-libs/zlib:=
"
# NOTE: upstream lacks avahi?, lua support
# TODO: elficon (needs libr), logind, libbfd/gcc, Xft iff tqt[Xft]

RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DTDE_MALLOC_FULL=ON
		-DWITH_CONSOLEKIT=$(usex consolekit)
		-DWITH_CRYPTSETUP=$(usex cryptsetup)
		-DWITH_LIBIDN=$(usex idn)
		-DWITH_SSL=$(usex ssl)
		-DWITH_LIBART=$(usex svg)
		-DWITH_PCRE=$(usex pcre)
		-DWITH_HSPELL=OFF
		-DWITH_ALSA=$(usex alsa)
		-DWITH_ARTS=$(usex arts)
		-DWITH_AVAHI=OFF
		-DWITH_CUPS=$(usex cups)
		-DWITH_INOTIFY=$(usex kernel_linux)
		-DWITH_JASPER=$(usex jpeg2k)
		-DWITH_LUA=OFF
		-DWITH_LZMA=$(usex lzma)
		-DWITH_NETWORK_MANAGER_BACKEND=$(usex networkmanager)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_ASPELL=$(usex spell)
		-DWITH_GAMIN=$(usex fam)
		-DWITH_PCSC=$(usex pcsc-lite)
		-DWITH_PKCS=$(usex pkcs11)
		-DWITH_MITSHM=$(usex shm)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UDEVIL=$(usex udevil)
		-DWITH_UDISKS2=$(usex udisks)
		-DWITH_UPOWER=$(usex upower)
		-DWITH_UTEMPTER=$(usex utempter)
		-DUTEMPTER_HELPER=/usr/sbin/utempter
		-DWITH_XCOMPOSITE=$(usex xcomposite)
		-DWITH_XRANDR=$(usex xrandr)
		-DWITH_SUDO_TDESU_BACKEND=$(usex sudo)
	)

	trinity-base_src_configure
}

src_install() {
	trinity-base_src_install

	dodir /etc/env.d
	# KDE implies that the install path is listed first in TDEDIRS and the user
	# directory (implicitly added) to be the last entry. Doing otherwise breaks
	# certain functionality. Do not break this (once again *sigh*), but read the code.
	# KDE saves the installed path implicitly and so this is not needed, /usr
	# is set in ${TDEDIR}/share/config/kdeglobals and so TDEDIRS is not needed.

	# List all the multilib libdirs
	local libdirs
	for libdir in $(get_all_libdirs); do
		libdirs="${TDEDIR}/${libdir}:${libdirs}"
	done

	# number goes down with version upgrade
	# NOTE: they should be less than kdepaths for kde-3.5
	cat <<EOF > "${D}/etc/env.d/42trinitypaths-${SLOT}"
CONFIG_PROTECT="${TDEDIR}/share/config ${TDEDIR}/env ${TDEDIR}/shutdown /usr/share/config"
#TDE_IS_PRELINKED=1
# Excessive flushing to disk as in releases before KDE 3.5.10. Usually you don't want that.
#TDE_EXTRA_FSYNC=1
EOF
	if use path; then
		cat <<EOF >> "${D}/etc/env.d/42trinitypaths-${SLOT}"
PATH=${TDEDIR}/bin
ROOTPATH=${TDEDIR}/sbin:${TDEDIR}/bin
LDPATH=${libdirs%:}
MANPATH=${TDEDIR}/share/man
XDG_DATA_DIRS="${TDEDIR}/share"
EOF
	fi
	cp "${FILESDIR}/tderun" "${WORKDIR}" || die
	sed -i "s|@TDEDIR@|${TDEDIR}|g;s|@TDELIBDIRS@|${libdirs%:}|" "${WORKDIR}/tderun" || die
	dobin "${WORKDIR}/tderun"

	# Make sure the target for the revdep-rebuild stuff exists. Fixes bug 184441.
	dodir /etc/revdep-rebuild

cat <<EOF > "${D}/etc/revdep-rebuild/50-trinity-${SLOT}"
SEARCH_DIRS="${TDEDIR}/bin ${TDEDIR}/lib*"
EOF

	# make documentation help accessible throught symlink
	dosym ${TDEDIR}/share/doc/kde/HTML ${TDEDIR}/share/doc/HTML

	trinity-base_create_tmp_docfiles
	trinity-base_install_docfiles
}

pkg_postinst () {
	if use sudo; then
		einfo "Remember sudo use flag sets only the default value"
		einfo "It can be overriden on a user-level by adding:"
		einfo "  [super-user-command]"
		einfo "    super-user-command=su"
		einfo "To the kdeglobal config file which is should be usually"
		einfo "located in the ~/.trinity/share/config/ directory."
	fi
}
