# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit git-2

DESCRIPTION="DLL to dump a usable backtrace to stderr for MingW/GCC software on Windows (requires application support)"
HOMEPAGE="https://github.com/luke-jr/win_backtrace"
LICENSE="BSD-2"

EGIT_REPO_URI="git://github.com/luke-jr/win_backtrace.git"
SLOT="0"
KEYWORDS=""

src_compile() {
	emake backtrace.dll || die
}

src_install() {
	dolib backtrace.dll
}
