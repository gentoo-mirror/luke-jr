# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AniDB Renamer"
SRC_URI="https://github.com/clip9/${PN}/tarball/a4110c5ef74a96ff914b7365db2ce91ea9ce629c?.tgz"
HOMEPAGE="${SRC_URI}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	virtual/perl-IO
	dev-perl/Digest-MD4
	virtual/perl-File-Spec
	dev-perl/File-HomeDir
	virtual/perl-Storable
	dev-lang/perl
"

S="${WORKDIR}/clip9-${PN}-a4110c5"

src_install() {
	exeinto "/usr/bin"
	doexe "adbren.pl"
}
