# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm bfin cris hppa m68k mips ia64 ppc ppc64 s390 sh sparc x86"
inherit kernel-2
detect_version

PATCH_VER="1"
SRC_URI="https://dev.gentoo.org/~vapier/dist/gentoo-headers-base-${PV}.tar.lzma"
[[ -n ${PATCH_VER} ]] && SRC_URI="${SRC_URI} https://dev.gentoo.org/~vapier/dist/gentoo-headers-${PV}-${PATCH_VER}.tar.lzma"
# also mirrored on https://luke.dashjr.org/mirror/misc/

KEYWORDS="-* ~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="|| ( app-arch/xz-utils app-arch/lzma-utils )"
RDEPEND=""

S=${WORKDIR}/gentoo-headers-base-${PV}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default

	[[ -n ${PATCH_VER} ]] && eapply "${WORKDIR}/${PV}"/*.patch
}

src_install() {
	kernel-2_src_install
	cd "${ED}"
	egrep -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.
	headers___fix $(find -type f)

	egrep -l -r -e '__[us](8|16|32|64)' "${ED}" | xargs grep -L linux/types.h

	# hrm, build system sucks
	find "${ED}" '(' -name '.install' -o -name '*.cmd' ')' -delete

	# provided by libdrm (for now?)
	rm -rf "${ED}"/$(kernel_header_destdir)/drm
}

src_test() {
	emake ARCH=$(tc-arch-kernel) headers_check || die
}
