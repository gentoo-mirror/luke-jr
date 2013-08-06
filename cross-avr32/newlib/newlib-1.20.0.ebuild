# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/newlib/newlib-1.20.0.ebuild,v 1.5 2013/02/09 04:40:10 vapier Exp $

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

myPATCHES="
	30-newlib-1.16.0-avr32.patch
	31-newlib-1.16.0-flashvault.patch
"

DESCRIPTION="Newlib is a C library intended for use on embedded systems"
HOMEPAGE="http://sourceware.org/newlib/"
SRC_URI="ftp://sourceware.org/pub/newlib/${P}.tar.gz"

for p in $myPATCHES; do
	SRC_URI+=" http://distribute.atmel.no/tools/opensource/avr32-gcc/newlib-1.16.0/$p"
done

LICENSE="NEWLIB LIBGLOSS GPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="-* ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="nls threads unicode crosscompile_opts_headers-only"
RESTRICT="strip"

NEWLIBBUILD="${WORKDIR}/build"

pkg_setup() {
	# Reject newlib-on-glibc type installs
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		case ${CHOST} in
			*-newlib|*-elf) ;;
			*) die "Use sys-devel/crossdev to build a newlib toolchain" ;;
		esac
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cris-install.patch
	epatch "${FILESDIR}"/${P}-arm-targets.patch #413547
	for p in $myPATCHES; do
		epatch "${DISTDIR}"/$p
	done
	cd newlib
	sed -i 's/\(m4_define(\[NEWLIB_VERSION\],\[[^]]\+\)/\1.atmel.1.1.0/' acinclude.m4
	autoreconf
}

src_configure() {
	# we should fix this ...
	unset LDFLAGS
	CHOST=${CTARGET} strip-unsupported-flags

	local myconf=""
	[[ ${CTARGET} == "spu" ]] \
		&& myconf="${myconf} --disable-newlib-multithread" \
		|| myconf="${myconf} $(use_enable threads newlib-multithread)"

	mkdir -p "${NEWLIBBUILD}"
	cd "${NEWLIBBUILD}"

	ECONF_SOURCE=${S} \
	econf \
		$(use_enable unicode newlib-mb) \
		$(use_enable nls) \
		${myconf}
}

src_compile() {
	emake -C "${NEWLIBBUILD}"
}

src_install() {
	mkdir -p "${D}"/usr/avr32/lib
	cd "${NEWLIBBUILD}"
	emake -j1 DESTDIR="${D}" install
#	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	# minor hack to keep things clean
	rm -fR "${D}"/usr/share/info
	rm -fR "${D}"/usr/info
}
