# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED=always
inherit virtualx

COMMITHASH='9730c09986dee2d0c265a8599ff4d6d573b2d1d6'

DESCRIPTION="Chromium extension to reduce resource usage by suspending tabs"
HOMEPAGE=""
SRC_URI="
	https://github.com/aciidic/thegreatsuspender-notrack/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/thegreatsuspender-notrack-${COMMITHASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

IUSE="+migration-tool"

RDEPEND="www-client/chromium"
DEPEND=""
BDEPEND="
	www-client/chromium
	>=dev-lang/python-3
"

USER_PRIVKEY="${PORTAGE_CONFIGROOT%/}/etc/portage/private-keys/${CATEGORY}/${PN}/${P}.pem"

pkg_pretend() {
	if [ -n "$REPLACING_VERSIONS" ]; then
		if [ "$MERGE_TYPE" != "binary" ] && ! [ -s "${USER_PRIVKEY}" ]; then
			local msg=eerror
			[ -n "${I_KNOW_WHAT_I_AM_DOING}" ] && msg=ewarn
			${msg}
			${msg} "You are upgrading ${CATEGORY}/${PN}, but no private key was found in"
			${msg} "${USER_PRIVKEY}"
			${msg} "This will require migrating suspended tabs, or potentially loss thereof."
			${msg} "To proceed anyway, unmerge the current version first."
			${msg}
			[ -n "${I_KNOW_WHAT_I_AM_DOING}" ] || die 'Missing private key for upgrade'
		fi
	fi
}

pkg_setup() {
	pkg_pretend
}

src_prepare() {
	if use migration-tool; then
		eapply "${FILESDIR}/${PV}-migrate.patch"
	fi
	default
}

src_compile() {
	addpredict /proc
	local chrome_pack_args=(
		--no-sandbox
		--disable-gpu
		--no-message-box
		--pack-extension='src'
	)
	if [ -s "${USER_PRIVKEY}" ]; then
		addread "${USER_PRIVKEY}"
		chrome_pack_args+=( --pack-extension-key="${USER_PRIVKEY}" )
	fi
	MESA_GLSL_CACHE_DIR="${T}" \
	virtx /usr/lib64/chromium-browser/chrome "${chrome_pack_args[@]}"
	local pkg_id=$(python3 "${FILESDIR}/get-pkgid.py" 'src.crx')
	echo "${pkg_id}" > pkg_id || die
	echo "{ \"external_crx\": \"/usr/share/${P}/${P}.crx\", \"external_version\": \"${PV}\" }" > "${pkg_id}.json" || die
}

src_install() {
	insinto "/usr/share/${P}"
	newins 'src.crx' "${P}.crx"

	insinto "/usr/share/chromium/extensions"
	doins "$(<pkg_id).json"
}

pkg_preinst() {
	if [ -e "${S}/src.pem" ]; then
		if [ -s "${USER_PRIVKEY}" ] || ! install -D --owner="${PORTAGE_USERNAME:-portage}" --mode=0400 --preserve-timestamps --verbose "${S}/src.pem" "${USER_PRIVKEY}"; then
			ewarn
			ewarn "${CATEGORY}/${PN} has successfully built, but using a new private"
			ewarn "key, which has not been saved. Upgrades will therefore have a new extension"
			ewarn "id, which may result in losing suspended tabs, or at least require"
			ewarn "migration."
			ewarn
		else
			einfo
			einfo "A private key was generated to build ${CATEGORY}/${PN}"
			einfo "It has been saved at:"
			einfo "${USER_PRIVKEY}"
			einfo "Rebuilding or upgrading will use this key to preserve suspended tabs"
			einfo
		fi
	fi
}
