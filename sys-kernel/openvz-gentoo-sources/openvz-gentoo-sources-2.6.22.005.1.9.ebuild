# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-2.6.22-r9.ebuild,v 1.5 2007/11/28 11:29:13 corsair Exp $

inherit versionator

CKV=$(get_version_component_range 1-3)
OVZ_KERNEL="$(get_version_component_range 4-5)"
[ "${OVZ_KERNEL:0:1}" == 'p' ] && OVZ_KERNEL="${OVZ_KERNEL:1}"
OVZ_KERNEL="ovz${OVZ_KERNEL}"

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="$(($(get_version_component_range 6)+1))"
inherit kernel-2
detect_version
EXTRAVERSION="-${OVZ_KERNEL}-gentoo$(get_version_component_range 6)"
KV_FULL="${OKV}${EXTRAVERSION}"
#KV="${KV_FULL}"
#S="${WORKDIR}/linux-${KV_FULL}"
detect_arch

KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86"
HOMEPAGE="
	http://www.openvz.org
	http://dev.gentoo.org/~dsd/genpatches
"

DESCRIPTION="Full sources including the OpenVZ and Gentoo patchsets for Linux ${OKV}"
OPENVZ_PATCH="patch-${OVZ_KERNEL}-combined.gz"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	http://download.openvz.org/kernel/branches/${OKV}/${OKV}-${OVZ_KERNEL}/patches/${OPENVZ_PATCH}
"

src_unpack() {
	local PATCHDIR="${WORKDIR}/LOCALpatches"
	local patch
	mkdir "${PATCHDIR}" && cd "${PATCHDIR}" || die "Failed to setup patch dir"
	for i in ${UNIPATCH_LIST_GENPATCHES}; do
		unpack "${i/${DISTDIR}/}"
	done
	for i in ${K_WANT_GENPATCHES}; do
		patch="${FILESDIR}/openvz-genpatches-${OKV}-${K_GENPATCHES_VER}.${i}.patch"
		[ -e "${patch}" ] || continue
		epatch "${patch}" || die "Failed to apply ${patch}"
	done
	UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 10"
	UNIPATCH_LIST_GENPATCHES="${PATCHDIR}"/*/*.patch
	
	ln -s "${UNIPATCH_LIST}" "${PATCHDIR}/0000-${OPENVZ_PATCH}"
	UNIPATCH_LIST="${PATCHDIR}/0000-${OPENVZ_PATCH}"
	
	K_WANT_GENPATCHES=""
	cd "${WORKDIR}"
	kernel-2_src_unpack
}

UNIPATCH_LIST="${DISTDIR}/${OPENVZ_PATCH}"
