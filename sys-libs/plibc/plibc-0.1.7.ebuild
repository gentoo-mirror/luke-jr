# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION=""
HOMEPAGE=""
LICENSE=""

SRC_URI="mirror://sourceforge/${PN}/0.1.7/${P}-src.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/PlibC-${PV}"

src_configure() {
	econf --disable-static
}

src_install() {
	emake install DESTDIR="${D}"
	prune_libtool_files
}
