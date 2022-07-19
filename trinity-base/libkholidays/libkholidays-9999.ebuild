# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
TRINITY_MODULE_NAME="tdepim"

inherit trinity-meta

DESCRIPTION="Trinity library to compute holidays."
KEYWORDS=""
IUSE+=""
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

TSM_EXTRACT_ALSO="libtdepim/"
