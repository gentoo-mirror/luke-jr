# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

inherit eutils git-r3 flag-o-matic toolchain-funcs

SRCTYPE="free"
DESCRIPTION="The Trinitie's Qt toolkit fork."
HOMEPAGE="http://trinitydesktop.org/"

# IMMTQT_P="tqt-x11-immodule-unified-tqt3.3.8-20070321-gentoo"

#SRC_URI="ftp://ftp.trolltech.com/tqt/source/tqt-x11-${SRCTYPE}-${PV}.tar.gz
#	immtqt? ( mirror://gentoo/${IMMTQT_P}.diff.bz2 )
#	immtqt-bc? ( mirror://gentoo/${IMMTQT_P}.diff.bz2 )"
EGIT_REPO_URI="https://scm.trinitydesktop.org/scm/git/tqt3"
LICENSE="|| ( QPL-1.0 GPL-2 GPL-3 )"

SLOT="3"
KEYWORDS=
IUSE="cups debug doc firebird ipv6 mysql nas nis opengl postgres sqlite xinerama"
# no odbc, immtqt and immtqt-bc support anymore.
# TODO: optional support for xrender and xrandr
# TODO: examples

RDEPEND="
	virtual/jpeg:=
	>=media-libs/freetype-2
	>=media-libs/libmng-1.0.9
	media-libs/libpng:=
	sys-libs/zlib
	x11-libs/libXft
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libSM
	cups? ( net-print/cups )
	firebird? ( dev-db/firebird )
	mysql? ( virtual/mysql )
	nas? ( >=media-libs/nas-1.5 )
	opengl? ( virtual/opengl virtual/glu )
	postgres? ( dev-db/postgresql:= )
	xinerama? ( x11-libs/libXinerama )
	!dev-qt/qt:3
	!dev-qt/qt-meta:3"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )"

#	immtqt? ( x11-proto/xineramaproto )
#	immtqt-bc? ( x11-proto/xineramaproto )"
#PDEPEND="odbc? ( ~dev-db/tqt-unixODBC-$PV )"

#S="${WORKDIR}/tqt-x11-${SRCTYPE}-${PV}"

pkg_setup() {
#	if use immtqt && use immtqt-bc ; then
#		ewarn
#		ewarn "immtqt and immtqt-bc are exclusive. You cannot set both."
#		ewarn "Please specify either immtqt or immtqt-bc."
#		ewarn
#		die
#	elif use immtqt ; then
#		ewarn
#		ewarn "You are going to compile binary imcompatible immodule for Qt. This means"
##		ewarn "you have to recompile everything depending on Qt after you install it."
#		ewarn "Be aware."
#		ewarn
#	fi

	export TQTDIR="${S}"

	CXX=$(tc-getCXX)
	if [[ ${CXX/g++/} != ${CXX} ]]; then
		PLATCXX="g++"
	elif [[ ${CXX/icpc/} != ${CXX} ]]; then
		PLATCXX="icc"
	else
		die "Unknown compiler ${CXX}."
	fi

	case ${CHOST} in
		*-freebsd*|*-dragonfly*)
			PLATNAME="freebsd" ;;
		*-openbsd*)
			PLATNAME="openbsd" ;;
		*-netbsd*)
			PLATNAME="netbsd" ;;
		*-darwin*)
			PLATNAME="darwin" ;;
		*-linux-*|*-linux)
			PLATNAME="linux" ;;
		*)
			die "Unknown CHOST, no platform choosed."
	esac

	if [[ "$CHOST" == *64* && "$PLATCXX" == "g++" ]]; then
		export PLATFORM="${PLATNAME}-${PLATCXX}-64"
	else
		export PLATFORM="${PLATNAME}-${PLATCXX}"
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PV}-qsettings-skip-mkdir.patch"

	# Apply user-provided patches
	eapply_user

	# Do not link with -rpath. See bug #75181.
	find "${S}"/mkspecs -name qmake.conf | xargs \
		sed -i -e 's:QMAKE_RPATH.*:QMAKE_RPATH =:'
#	if use immtqt || use immtqt-bc ; then
#		eapply ../${IMMTQT_P}.diff
#		sh make-symlinks.sh || die "make symlinks failed"
#
#		eapply "${FILESDIR}"/tqt-3.3.8-immtqt+gcc-4.3.patch
#	fi

	# set c/xxflags and ldflags
	strip-flags
	append-flags -fno-strict-aliasing

	sed -i -e "s:QMAKE_CFLAGS_RELEASE.*=.*:QMAKE_CFLAGS_RELEASE=${CFLAGS}:" \
		   -e "s:QMAKE_CXXFLAGS_RELEASE.*=.*:QMAKE_CXXFLAGS_RELEASE=${CXXFLAGS}:" \
		   -e "s:QMAKE_LFLAGS_RELEASE.*=.*:QMAKE_LFLAGS_RELEASE=${LDFLAGS}:" \
		   -e "s:\<QMAKE_CC\>.*=.*:QMAKE_CC=$(tc-getCC):" \
		   -e "s:\<QMAKE_CXX\>.*=.*:QMAKE_CXX=$(tc-getCXX):" \
		   -e "s:\<QMAKE_LINK\>.*=.*:QMAKE_LINK=$(tc-getCXX):" \
		   -e "s:\<QMAKE_LINK_SHLIB\>.*=.*:QMAKE_LINK_SHLIB=$(tc-getCXX):" \
		   -e "s:\<QMAKE_STRIP\>.*=.*:QMAKE_STRIP=:" \
		"${S}/mkspecs/${PLATFORM}/qmake.conf" || die

	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e "s:/lib$:/$(get_libdir):" \
			"${S}/mkspecs/${PLATFORM}/qmake.conf" || die
	fi

	sed -i -e "s:CXXFLAGS.*=:CXXFLAGS=${CXXFLAGS} :" \
		   -e "s:LFLAGS.*=:LFLAGS=${LDFLAGS} :" \
		"${S}/qmake/Makefile.unix" || die

	# remove docs from install (if we need it, we install with dodoc later)
	sed -i -e '/INSTALLS.*=.*htmldocs/d' \
		"${S}/src/qt_install.pri"
	
	# move manpages out of doc so it can be installed separately
	mv doc/man . || die
}

src_configure() {
	# common opts
	myconf=" -sm -thread -stl -no-verbose -no-verbose -verbose -largefile -tablet"
	myconf+=" $(echo -{qt-imgfmt-,system-lib}{jpeg,mng,png})"
	myconf+=" -platform ${PLATFORM} -xplatform ${PLATFORM}"
	myconf+=" -xft -xrender -prefix /usr"
	myconf+=" -headerdir /usr/include/tqt3"
	myconf+=" -plugindir /usr/libexec/tqt3/plugins"
	myconf+=" -datadir /usr/share/tqt3"
	myconf+=" -translationdir /usr/share/tqt3/translations"
	myconf+=" -sysconfdir /etc/tqt3"
	myconf+=" -libdir /usr/$(get_libdir) -fast -no-sql-odbc"

	[ "$(get_libdir)" != "lib" ] && myconf+="${myconf} -L/usr/$(get_libdir)"

	# unixODBC support is now a PDEPEND on dev-db/tqt-unixODBC; see bug 14178.
	use nas		&& myconf+=" -system-nas-sound"
	use nis		&& myconf+=" -nis" || myconf+=" -no-nis"
	use mysql	&& myconf+=" -plugin-sql-mysql -I/usr/include/mysql -L/usr/$(get_libdir)/mysql" || myconf+=" -no-sql-mysql"
	use postgres	&& myconf+=" -plugin-sql-psql -I/usr/include/postgresql/server -I/usr/include/postgresql/pgsql -I/usr/include/postgresql/pgsql/server" || myconf+=" -no-sql-psql"
	use firebird    && myconf+=" -plugin-sql-ibase -I/opt/firebird/include" || myconf+=" -no-sql-ibase"
	use sqlite	&& myconf+=" -plugin-sql-sqlite" || myconf+=" -no-sql-sqlite"
	use cups	&& myconf+=" -cups" || myconf+=" -no-cups"
	use opengl	&& myconf+=" -enable-module=opengl" || myconf+=" -disable-opengl"
	use debug	&& myconf+=" -debug" || myconf+=" -release -no-g++-exceptions"
	use xinerama    && myconf+=" -xinerama" || myconf+=" -no-xinerama"

	myconf+=" -system-zlib -qt-gif"

	use ipv6        && myconf+=" -ipv6" || myconf+=" -no-ipv6"
#	use immtqt-bc	&& myconf+=" -inputmethod"
#	use immtqt	&& myconf+=" -inputmethod -inputmethod-ext"

	myconf+=" -dlopen-opengl"

	export YACC='byacc -d'
	tc-export CC CXX
	export LINK="$(tc-getCXX)"

	einfo ./configure ${myconf}
	./configure ${myconf} || die
}

src_compile() {
	emake src-qmake src-moc sub-src

	export DYLD_LIBRARY_PATH="${S}/lib:/usr/X11R6/lib:${DYLD_LIBRARY_PATH}"
	export LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}"

	emake sub-tools

# 	if use examples; then
# 		emake sub-tutorial sub-examples
# 	fi

	# Make the msg2qm utility (not made by default)
	cd "${S}"/tools/msg2tqm
	../../bin/tqmake || die
	emake

	# Make the qembed utility (not made by default)
	cd "${S}"/tools/qembed
	../../bin/tqmake || die
	emake

}

src_install() {
	emake INSTALL_ROOT="${D}" install
	# Next executables are missing to be installed:
	#	/usr/qt/3/bin/findtr
	#	/usr/qt/3/bin/conv2ui
	#	/usr/qt/3/bin/qt20fix
	#	/usr/qt/3/bin/qtrename140
	# I'm not sure if they are really needed

	keepdir /etc/tqt3

	doman man/man*/*

	if use doc; then
		dodoc -r doc/*
	fi

# 	if use examples; then
# 		find "${S}"/examples "${S}"/tutorial -name Makefile | \
# 			xargs sed -i -e "s:${S}:/usr/share/doc/:g"
# 
# 		dodoc -r "${S}"/examples
# 		dodoc -r "${S}"/tutorial
# 	fi

	dodoc FAQ README README-QT.TXT
#	if use immtqt || use immtqt-bc ; then
#		dodoc "${S}"/README.immodule
#	fi
}

pkg_postinst() {
	echo
	elog "After a rebuild of TQt, it can happen that TQt plugins (such as TQt/TDE styles,"
	elog "or widgets for the TQt designer) are no longer recognized.  If this situation"
	elog "occurs you should recompile the packages providing these plugins,"
	elog "and you should also make sure that TQt and its plugins were compiled with the"
	elog "same version of GCC."
	echo
}
