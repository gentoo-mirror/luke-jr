# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
QT3SUPPORT_REQUIRED="true"
inherit kde4-meta

DESCRIPTION="Library for encryption handling"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs4)
	app-crypt/gpgme
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

KMSAVELIBS="true"
KMEXTRACTONLY="kleopatra/"

PATCHES=( "${FILESDIR}/${P}-gcc-6.3.patch" )
