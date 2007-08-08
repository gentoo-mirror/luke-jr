inherit eutils

DESCRIPTION="allows you to move programs between X Window System displays"
HOMEPAGE="http://packages.debian.org/unstable/x11/xmove"
dPV="${PV/_p/-}"
dPV="${dPV/_/}"
oPV="${dPV/-*/}"
SRC_URI="http://ftp.debian.org/debian/pool/main/x/${PN}/${PN}_${oPV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/x/${PN}/${PN}_${dPV}.diff.gz
"
LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}/${PN}"{,"-${oPV}"}
	epatch ${WORKDIR}/${PN}_${dPV}.diff
}
S="${WORKDIR}/${PN}-${oPV}"

src_compile() {
	for i in xmove xmovectrl; do
	(
		cd $i
		xmkmf
		touch "$i.man"
		emake
	) || die "building $i failed"
	done
	(
		cd xmove/lib
		emake -f Makefile.Linux || die "building xmove/lib failed"
	)
}

src_install() {
	exeinto '/usr/bin'
	doexe "xmovectrl/xmovectrl"
	doexe "xmove/xmove"
	dolib "xmove/lib/libatommap.so.1.1"
	dodir "/usr/lib/xmove"
	mv "${D}/usr/lib/"{,xmove/}"libatommap.so.1.1"
	dosym libatommap.so.1.1 /usr/lib/xmove/libatommap.so
	dodoc "doc/"* README
	dodoc xmove/changes.list
	doman man/man1/xmove.1
	doman man/man1/xmovectrl.1
}
