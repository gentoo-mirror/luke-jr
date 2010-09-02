# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kexec-tools/kexec-tools-2.0.1-r1.ebuild,v 1.1 2010/07/30 20:21:13 zorry Exp $

EAPI=2

inherit eutils flag-o-matic

MyP="${P/_pre0/}"
DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools"
SRC_URI="mirror://kernel/linux/utils/kernel/kexec/${MyP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="xen zlib"
DEPEND="zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MyP}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.0.0-respect-LDFLAGS.patch"

	# to disable the -fPIE -pie in the hardened compiler
	if gcc-specs-pie ; then
		filter-flags -fPIE
		append-ldflags -nopie
	fi
}

src_configure() {
	econf $(use_with zlib) $(use_with xen)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	doman kexec/kexec.8
	dodoc News AUTHORS TODO

	newinitd "${FILESDIR}"/kexec.init kexec || die
	newconfd "${FILESDIR}"/kexec.conf kexec || die
}
