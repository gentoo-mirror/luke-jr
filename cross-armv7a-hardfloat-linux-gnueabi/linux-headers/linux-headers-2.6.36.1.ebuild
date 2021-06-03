# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm bfin cris hppa m68k mips ia64 ppc ppc64 s390 sh sparc x86"
inherit kernel-2
detect_version

PATCH_VER="1"
SRC_URI="https://luke.dashjr.org/mirror/gentoo/gentoo-headers-base-${PV}.tar.xz"
[[ -n ${PATCH_VER} ]] && SRC_URI="${SRC_URI} https://luke.dashjr.org/mirror/gentoo/gentoo-headers-${PV%.1}-${PATCH_VER}.tar.xz"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S=${WORKDIR}/gentoo-headers-base-${PV}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default

	[[ -n ${PATCH_VER} ]] && eapply "${WORKDIR}/${PV%.1}"/*.patch
}

src_test() {
	einfo "Possible unescaped attribute/type usage"
	egrep -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.

	emake ARCH=$(tc-arch-kernel) headers_check
}

src_install() {
	kernel-2_src_install

	# hrm, build system sucks
	find "${ED}" '(' -name '.install' -o -name '*.cmd' ')' -delete
	find "${ED}" -depth -type d -delete 2>/dev/null

	# provided by libdrm (for now?)
	rm -rf "${ED}"/$(kernel_header_destdir)/drm
}
