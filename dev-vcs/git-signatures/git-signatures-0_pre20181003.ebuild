# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMITHASH='979f207a1c1342b9342aa58be914fc51a0c62f87'
DESCRIPTION="Attach an arbitrary number of GPG signatures to git commits and tags"
HOMEPAGE="https://github.com/hashbang/git-signatures"
SRC_URI="https://github.com/hashbang/${PN}/archive/${COMMITHASH}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"
RDEPEND="
	app-shells/bash
	sys-apps/util-linux
	sys-apps/coreutils
	>=app-crypt/gnupg-2.2
	>=dev-vcs/git-2.1
"
DEPEND=""
BDEPEND="
	sys-devel/make
	app-shells/bash
	test? (
		dev-util/bats
		${RDEPEND}
	)
"
S="${WORKDIR}/${PN}-${COMMITHASH}"

src_compile() {
	true
}

src_test() {
	make test || die
}

src_install() {
	dodoc README.md
	make install prefix="${D}/usr" || die
}
