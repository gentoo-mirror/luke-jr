# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils git-r3

DESCRIPTION="Qt Jabber client, with Licq-like interface"
HOMEPAGE="http://${PN}-im.org/"
LICENSE="GPL-2 LGPL-2.1 l10n_mk? ( GPL-3 ) l10n_zh_TW? ( BSD )"

EGIT_REPO_URI="git://github.com/psi-im/${PN}.git"
SLOT="0"
KEYWORDS=""
IUSE="aspell dbus debug doc enchant gpg hunspell plugins qt4 qt5 ssl webkit whiteboarding xscreensaver"
PLOCALES="be cs de eo es es_ES fr he it ja kk mk pl pt_BR ru sl sv uk ur_PK vi zh_CN zh_TW"
for psi_l10n in ${PLOCALES}; do
	IUSE+=" l10n_${psi_l10n}"
done

DEPEND="
	qt4? (
		dev-qt/qtgui:4
		dbus? ( dev-qt/qtdbus:4 )
		webkit? ( dev-qt/qtwebkit:4 )
		whiteboarding? ( dev-qt/qtsvg:4 )
	)
	qt5? (
		dev-qt/qtgui:5
		dbus? ( dev-qt/qtdbus:5 )
		webkit? ( dev-qt/qtwebkit:5 )
		whiteboarding? ( dev-qt/qtsvg:5 )
	)
	app-crypt/qca[qt4?,qt5?,gpg?]
	ssl? ( app-crypt/qca[openssl] )
	net-libs/jdns[qt4?,qt5?]
	sys-libs/zlib[minizip]
	aspell? ( app-text/aspell )
	enchant? ( app-text/enchant )
	hunspell? ( app-text/hunspell )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
REQUIRED_USE="
	^^ ( qt4 qt5 )
	?? (
		aspell
		enchant
		hunspell
	)
"

PSI_USERVARS="LIVE_REPO LIVE_BRANCH LIVE_COMMIT LIVE_COMMIT_DATE"

l10n_for_each_locale_do() {
	# l10n.eclass is trying to use obsolete linguas_*
	local l10n
	for l10n in ${PLOCALES}; do
		use "l10n_${l10n}" || continue
		"$@" "$l10n"
	done
}

psi_get_uservar() {
	local repo="$1" uv="$2"
	local var="psi_${uv}" val="$(eval echo \"\${psi_${repo}_${uv}}\")"
	if [ -n "$val" ]; then
		eval "$var='$val'"
	else
		eval "unset $var"
	fi
}

psi_vars() {
	local repo="$1" uv
	for uv in ${PSI_USERVARS}; do
		if [ -z "${psi_main_SET}" ]; then
			eval "psi_main_${uv}=\"\$psi_${uv}\""
		fi
		psi_get_uservar $repo $uv
	done
	psi_main_SET=1
	case "$repo" in
	main)
		EGIT_REPO_URI="git://github.com/psi-im/psi.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
		;;
	l10n)
		EGIT_REPO_URI="git://github.com/psi-im/psi-translations.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/l10n"
		;;
	esac
}

psi_call_git() {
	local gitfunc="$1" repo

	for repo in main l10n; do
		psi_vars $repo
		$gitfunc
	done
}

psi_check_needrebuild() {
	if git-r3_pkg_needrebuild; then
		psi_needs_rebuild=true
	fi
}

pkg_needrebuild() {
	psi_needs_rebuild=false
	psi_call_git psi_check_needrebuild
	$psi_needs_rebuild
}

src_unpack() {
	psi_call_git git-r3_src_fetch
	psi_call_git git-r3_checkout
}

src_prepare() {
	rm -r iris/src/jdns

	local supported_l10n=$(tr '\n' ' ' <../l10n/langs)
	[ "${supported_l10n% }" = "${PLOCALES}" ] || ewarn "PLOCALES needs updating to: ${supported_l10n% }"

	eapply_user
}

src_configure() {
	# econf won't work here since it isn't standard autotools
	./configure \
		--prefix="${EPREFIX}/usr" \
		--qtselect=$(usex qt5 5 4) \
		$(usex debug --debug --release) \
		--no-separate-debug-info \
		$(usex dbus '' --disable-qdbus) \
		$(usex webkit --enable-webkit '') \
		--disable-growl \
		$(usex whiteboarding --enable-whiteboarding '') \
		$(usex xscreensaver '' --disable-xss) \
		$(usex aspell '' --disable-aspell) \
		$(usex enchant '' --disable-enchant) \
		$(usex hunspell '' --disable-hunspell) \
		$(usex plugins '' --disable-plugins) \
		|| die 'configure failed'
}

src_compile() {
	emake

	if use doc; then
		cd doc
		mkdir -p api # 259632
		make api_public || die "make api_public failed"
	fi

	build_locale() {
		lrelease "../l10n/${1}/${PN}_${1}.ts" || die "lrelease ${1} failed"
	}
	l10n_for_each_locale_do build_locale
}

src_install() {
	emake INSTALL_ROOT="${D}" STRIP=true install

	# this way the docs will be installed in the standard gentoo dir
	rm -f "${ED}"/usr/share/${MY_PN}/{COPYING,README}
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	use doc && dohtml -r doc/api

	insinto "/usr/share/${PN}"
	install_locale() {
		doins "../l10n/${1}/${PN}_${1}.qm"
	}
	l10n_for_each_locale_do install_locale
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
