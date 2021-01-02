# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Calibrates the power consumption of a mobile device that has a battery power source."
HOMEPAGE="https://kernel.ubuntu.com/~cking/power-calibrate/"
SRC_URI="https://kernel.ubuntu.com/~cking/tarballs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	# Install raw uncompressed manpage
	sed -i 's/\.gz\($\| \)/\1/' Makefile || die

	default
}
