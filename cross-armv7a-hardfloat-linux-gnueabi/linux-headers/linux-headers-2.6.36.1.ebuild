# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm bfin cris hppa m68k mips ia64 ppc ppc64 s390 sh sparc x86"
inherit kernel-2
detect_version

PATCH_VER="1"
SRC_URI="https://luke.dashjr.org/mirror/gentoo/gentoo-headers-base-${PV}.tar.xz"
[[ -n ${PATCH_VER} ]] && SRC_URI="${SRC_URI} https://luke.dashjr.org/mirror/gentoo/gentoo-headers-${PV%.1}-${PATCH_VER}.tar.xz"
S="${WORKDIR}/gentoo-headers-base-${PV}"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	app-arch/xz-utils
"

[[ -n ${PATCH_VER} ]] && PATCHES=( "${WORKDIR}"/${PV%.1} )

src_unpack() {
	# avoid kernel-2_src_unpack
	default
}

src_prepare() {
	# avoid kernel-2_src_prepare
	default
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
	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die

	# provided by libdrm (for now?)
	rm -rf "${ED}"/$(kernel_header_destdir)/drm || die
}
