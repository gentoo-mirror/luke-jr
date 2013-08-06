# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.20.1-r1.ebuild,v 1.16 2012/05/31 04:45:38 vapier Exp $

PATCHVER="1.2"
ELF2FLT_VER=""
inherit toolchain-binutils

DESCRIPTION="Tools necessary to build programs for AVR32 microcontrollers"
myPATCHES="
	20-binutils.2.20.1-avr32-autoconf.patch
	30-binutils-2.20.1-avr32-bfd.patch
	31-binutils-2.20.1-avr32-binutils.patch
	32-binutils-2.20.1-avr32-gas.patch
	33-binutils-2.20.1-avr32-include.patch
	34-binutils-2.20.1-avr32-ld.patch
	35-binutils-2.20.1-avr32-opcodes.patch
	40-binutils-2.20.1-avr32-fixes.patch
	41-binutils-2.20.1-avr32-fpu.patch
	42-binutils-2.20.1-avr32-bug-7435.patch
	50-binutils-2.20.1-avr32-mxt768e.patch
	51-binutils-2.20.1-avr32-uc3c.patch
	52-binutils-2.20.1-avr32-uc3l0128.patch
	53-binutils-2.20.1-avr32-uc3a4.patch
	54-binutils-2.20.1-avr32-uc3d.patch
	55-binutils-2.20.1-avr32-uc3l3l4.patch
"
PATCHES=()
for p in $myPATCHES; do
	SRC_URI+=" http://distribute.atmel.no/tools/opensource/avr32-gcc/binutils-2.20.1/$p"
	PATCHES+=( "${DISTDIR}/$p" )
done

KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"

pkg_setup() {
	is_cross || die "Only cross-compile builds are supported"
}

src_unpack() {
	toolchain-binutils_src_unpack
	
	cd "${P}"
	sed -i 's/\(avr-dis.c\)/\1 avr32-asm.c avr32-dis.c avr32-opc.c/' opcodes/Makefile.am
	
	autoreconf -f -I config
	for d in gold intl libiberty gprof ld binutils etc gas opcodes bfd
	do
		(
			cd "$d"
			autoreconf -f
		)
	done
	
	mkdir fixheaders
	cd fixheaders
	../bfd/configure
	make headers
}
