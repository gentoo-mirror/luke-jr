# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit flag-o-matic eutils alternatives libtool

DESCRIPTION="an SQL Database Engine in a C Library"
HOMEPAGE="http://www.sqlite.org/"
SRC_URI="http://www.sqlite.org/${P}.tar.gz"
SRC_URI="http://be.lunar-linux.org/lunar/cache/${P}.tar.gz"

LICENSE="as-is"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="debug doc soundex tcl +threadsafe"
RESTRICT="!tcl? ( test )"

DEPEND="doc? ( dev-lang/tcl )
	tcl? ( dev-lang/tcl )"
RDEPEND="tcl? ( dev-lang/tcl )"

SOURCE="/usr/bin/lemon"
ALTERNATIVES="${SOURCE}-3 ${SOURCE}-0"

pkg_setup() {
	# test
	if has test ${FEATURES}; then
		if ! has userpriv ${FEATURES}; then
			ewarn "The userpriv feature must be enabled to run tests."
			eerror "Testsuite will not be run."
		fi
		if ! use tcl; then
			ewarn "You must enable the tcl use flag if you want to run the test"
			ewarn "suite."
			eerror "Testsuite will not be run."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/sqlite-3.3.3-tcl-fix.patch

	epatch "${FILESDIR}"/sandbox-fix2.patch

	# Fix broken tests that are not portable to 64bit arches
	epatch "${FILESDIR}"/sqlite-64bit-test-fix.patch
	epatch "${FILESDIR}"/sqlite-64bit-test-fix2.patch

	# Respect LDFLAGS wrt bug #156299
	sed -i -e 's/^LTLINK = .*/& $(LDFLAGS)/' Makefile.in

	elibtoolize
	epunt_cxx
}

src_compile() {
	# not available via configure and requested in bug #143794
	use soundex && append-flags -DSQLITE_SOUNDEX=1

	econf \
		$(use_enable debug) \
		$(use_enable threadsafe) \
		$(use_enable threadsafe cross-thread-connections) \
		$(use_enable tcl) \
		|| die "econf failed"

	emake all || die "emake all failed"

	if use doc ; then
		emake doc || die "emake doc failed"
	fi
}

src_test() {
	if use tcl ; then
		if has userpriv ${FEATURES} ; then
			if use debug ; then
				emake fulltest || die "some test failed"
			else
				emake test || die "some test failed"
			fi
		fi
	fi
}

src_install () {
	emake \
		DESTDIR="${D}" \
		TCLLIBDIR="/usr/$(get_libdir)" \
		install \
		|| die "emake install failed"

	newbin lemon lemon-${SLOT} || die

	dodoc README VERSION || die
	doman sqlite3.1 || die

	use doc && dohtml doc/* art/*.gif || die
}
