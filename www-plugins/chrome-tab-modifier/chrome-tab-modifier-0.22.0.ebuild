# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EXTENSION_ID='hcbgadmbdkiilgpifjgcakjehmafcjai'

DESCRIPTION="Chromium extension to manipulate tabs based on URL matching"
HOMEPAGE="https://github.com/sylouuu/chrome-tab-modifier"
SRC_URI="
	https://clients2.google.com/service/update2/crx?response=redirect&prodversion=89.0.4389.114&acceptformat=crx2,crx3&x=id%3D${EXTENSION_ID}%26uc -> ${P}.crx
"
# NOTE: https://f1.crx4chrome.com/crx.php?i=${EXTENSION_ID}&v=${PV}&p=5842 differs, and hates wget UA

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

IUSE=""

RDEPEND="www-client/chromium"
DEPEND=""
BDEPEND=""

src_compile() {
	echo "{ \"external_crx\": \"/usr/share/${P}/${P}.crx\", \"external_version\": \"${PV}\" }" > "${EXTENSION_ID}.json" || die
}

src_install() {
	insinto "/usr/share/${P}"
	doins "${DISTDIR}/${P}.crx"

	insinto "/usr/share/chromium/extensions"
	doins "${EXTENSION_ID}.json"
}
