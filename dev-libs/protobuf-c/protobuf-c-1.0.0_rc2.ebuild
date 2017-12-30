# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/protobuf-c/protobuf-c-1.0.0_rc2.ebuild,v 1.1 2014/07/01 06:58:18 radhermit Exp $

EAPI=5

inherit autotools-utils

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="code generator and runtime libraries to use Protocol Buffers (protobuf) from pure C"
HOMEPAGE="https://github.com/protobuf-c/protobuf-c/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs test"

RDEPEND="dev-libs/protobuf"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if ! use test; then
		sed -i 's/BUILD_COMPILER_TRUE.*\bt\///;T;d' "${S}/Makefile.in"
	fi
}