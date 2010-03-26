# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

DESCRIPTION="Etckeeper is a collection of tools to let /etc be stored in a git, mercurial, or bzr repository."
HOMEPAGE="http://kitenet.net/~joey/code/etckeeper/"

EGIT_REPO_URI="git://git.kitenet.net/etckeeper"
EGIT_TREE="${PV}"

LICENSE="GPL-2"
IUSE="bash-completion bzr darcs git mercurial"
KEYWORDS="~arm ~amd64 ~hppa ~ppc ~sparc ~x86"
SLOT="0"

DEPEND='
	bzr? ( dev-vcs/bzr )
'
RDEPEND="${DEPEND} "'
	bash-completion? ( app-shells/bash-completion )
	darcs? ( dev-vcs/darcs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	sys-apps/portage
'

src_unpack() {
	git_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/etckeeper-gentoo.patch
	cp "${FILESDIR}/portage.bashrc" .
}

src_compile() {
        if use bzr; then
		emake || die "make failed : problem in support python for bzr" 
	fi
	local pm=git
	if use git; then
		true
	elif use bzr; then
		pm=bzr
	elif use darcs; then
		pm=darcs
	elif use mercurial; then
		pm=hg
	fi
	sed -i "s/^# \\(VCS=\"${pm}\\)/\\1/" etckeeper.conf
}

src_install() {
	emake DESTDIR=${D} install || die "make install failed"
	
	use bash-completion ||
	rm -r "${D}/etc/bash_completion.d"
	
	dodoc README TODO
}

pkg_postinst() {
	einfo "If you want etckeeper to automatically make commits, add the following"
	einfo "line to /etc/portage/bashrc :"
	einfo "        source /etc/portage/etckeeper.bashrc"
}
