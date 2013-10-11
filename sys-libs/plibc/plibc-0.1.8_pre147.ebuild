# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils subversion

DESCRIPTION=""
HOMEPAGE=""
LICENSE=""

SRC_URI=""
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"
ESVN_REVISION=147
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

ESVN_BOOTSTRAP="sh bootstrap"

src_configure() {
	econf --disable-static
}

src_install() {
	emake install DESTDIR="${D}"
	prune_libtool_files
}
