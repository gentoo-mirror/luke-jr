# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION=""
HOMEPAGE=""
LICENSE="BSD"

SRC_URI="http://www.atmel.com/Images/${P}.zip"
SLOT="0"
KEYWORDS=""

src_install() {
	local Dt="${D}/usr/${CATEGORY/cross-//}/include/"
	mkdir -p "${Dt}"
	if grep -q 32 <<<"${CATEGORY}"; then
		mv "${S}/avr32" "${Dt}"
	else
		mv "${S}/avr" "${Dt}"
	fi
}
