# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
TRINITY_MODULE_TYPE="dependencies"
TRINITY_MODULE_NAME="${PN}"

inherit trinity-base

DESCRIPTION="Interface and abstraction library for Qt and Trinity"
HOMEPAGE="http://trinitydesktop.org/"

LICENSE="GPL-2"
KEYWORDS=
IUSE=""
SLOT="0"

DEPEND=">=dev-qt/tqt-9999"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
	    -DQT_VERSION=3
	 )

	 cmake-utils_src_configure
}
