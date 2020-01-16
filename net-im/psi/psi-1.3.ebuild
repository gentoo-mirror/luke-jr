# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be bg ca cs de en eo es et fa fi fr he hu it ja kk mk nl pl pt pt_BR ru sk sl sr@latin sv sw uk ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en"

inherit l10n qmake-utils xdg-utils

DESCRIPTION="Qt XMPP client"
HOMEPAGE="http://psi-im.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	https://github.com/psi-im/psi-l10n/archive/${PV}.tar.gz -> psi-l10n-${PV}.tar.gz
	otr? ( https://github.com/psi-im/plugins/archive/${PV}.tar.gz -> ${PN}-plugins-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aspell crypt dbus debug doc enchant +hunspell otr ssl webengine webkit whiteboarding xscreensaver"

# qconf generates not quite compatible configure scripts
QA_CONFIGURE_OPTIONS=".*"

REQUIRED_USE="
	?? ( aspell enchant hunspell )
	webengine? ( !webkit )
"

RDEPEND="
	app-crypt/qca:2
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	net-dns/libidn
	sys-libs/zlib[minizip]
	x11-libs/libX11
	x11-libs/libxcb
	aspell? ( app-text/aspell )
	dbus? ( dev-qt/qtdbus:5 )
	enchant? ( >=app-text/enchant-1.3.0 )
	hunspell? ( app-text/hunspell:= )
	otr? (
		app-text/htmltidy
		dev-libs/libgcrypt
		dev-libs/libgpg-error
		net-libs/libotr
	)
	webengine? (
		>=dev-qt/qtwebchannel-5.7:5
		>=dev-qt/qtwebengine-5.7:5[widgets]
	)
	webkit? ( dev-qt/qtwebkit:5 )
	whiteboarding? ( dev-qt/qtsvg:5 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PDEPEND="
	crypt? ( app-crypt/qca[gpg] )
	ssl? ( app-crypt/qca:2[ssl] )
"

RESTRICT="test"

src_prepare() {
	mv "${WORKDIR}/plugins-${PV}/generic" src/plugins/

	default
}

src_configure() {
	CONF=(
		--no-separate-debug-info
		--qtdir="$(qt5_get_bindir)/.."
		$(use_enable aspell)
		$(use_enable dbus qdbus)
		$(use_enable enchant)
		$(use_enable hunspell)
		$(use_enable xscreensaver xss)
		$(use_enable whiteboarding)
	)

	use debug && CONF+=("--debug")
	use webengine && CONF+=("--enable-webkit" "--with-webkit=qtwebengine")
	use webkit && CONF+=("--enable-webkit" "--with-webkit=qtwebkit")

	econf "${CONF[@]}"

	eqmake5 psi.pro

	use otr && ( cd src/plugins/generic/otrplugin/ && eqmake5 otrplugin.pro )
}

src_compile() {
	emake
	use doc && emake -C doc api_public
	use otr && emake -C src/plugins/generic/otrplugin
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	# this way the docs will be installed in the standard gentoo dir
	rm "${ED}"/usr/share/psi/{COPYING,README} || die "Installed file set seems to be changed by upstream"
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	use doc && HTML_DOCS=( doc/api/. )
	einstalldocs

	insinto /usr/$(get_libdir)/psi/plugins
	use otr && doins src/plugins/generic/otrplugin/libotrplugin.so

	# install translations
	local mylrelease="$(qt5_get_bindir)"/lrelease
	cd "${WORKDIR}/psi-l10n-${PV}" || die
	insinto /usr/share/psi
	install_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "lrelease ${1} failed"
		doins "translations/${PN}_${1}.qm"
	}
	l10n_for_each_locale_do install_locale
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
