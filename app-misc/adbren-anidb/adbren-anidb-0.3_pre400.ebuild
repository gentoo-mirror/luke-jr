# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AniDB Renamer"
MyPN="${PN/-anidb/}"
HOMEPAGE="http://dev.anidb.info/websvn/listing.php?repname=AniDB+CSS&path=%2Ftrunk%2Fudp_clients%2F${MyPN}"
SvnRev="${PV/*_pre/}"
SRC_URI="http://luke.dashjr.org/pub/${P/0.3_pre/r}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	!app-misc/adbren
	dev-perl/Getopt-ArgvFile
	virtual/perl-Getopt-Long
	dev-perl/AniDB
	dev-lang/perl
"

S="${WORKDIR}/${MyPN}.r${SvnRev}"

MyPL='adbren.pl'

src_install() {
	exeinto "/usr/bin"
	doexe "${MyPL}" || die
}
