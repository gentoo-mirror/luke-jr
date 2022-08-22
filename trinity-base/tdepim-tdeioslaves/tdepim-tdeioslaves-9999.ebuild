# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
TRINITY_MODULE_NAME="tdepim"

inherit trinity-meta

TSM_EXTRACT="tdeioslave"
TRINITY_SUBMODULE="tdeioslave"

DESCRIPTION="PIM Trinity IO slaves"
KEYWORDS=
IUSE="sasl sieve"

REQUIRED_USE="
	sasl? ( sieve )
	sieve? ( sasl )
"
DEPEND="
	|| (
		(
			net-libs/libtirpc
			net-libs/rpcsvc-proto
		)
		<sys-libs/glibc-2.26[rpc]
	)
	trinity-base/libkmime
	sasl? ( virtual/gsasl )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DWITH_SASL=$(usex sieve)
	)

	trinity-meta_src_configure
}
