# Copyright 2010 OpenMethods
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

myPN="lib${PN}"
myP="${myPN}-${PV}"
DESCRIPTION="An open source JavaScript engine developed by Google"
HOMEPAGE="http://code.google.com/p/${PN}/"
SRC_URI="mirror://debian/pool/main/libv/${myPN}/${myPN}_${PV}.orig.tar.gz"
LICENSE="BSD"

SLOT="${PV/.*/}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="d8 debug +debugger disassembler oprofile profile +profiler readline samples snapshot v8hiddenvisibility"

# NOT IMPLEMENTED IUSE:
#sample=shell,process
#soname=on?
#simulator=arm?
#regexp=native,interpreted
#os=freebsd,linux,macos,win32,android,openbsd

DEPEND='
	oprofile? ( >=dev-util/oprofile-0.9.4 )
	readline? ( sys-libs/readline )
'
RDEPEND="${DEPEND}"'
'
DEPEND="${DEPEND}"'
	dev-util/scons
	>=dev-lang/python-2.4
	>=sys-devel/gcc-4
'

inherit eutils

S="${WORKDIR}/${myP}"

myParams() {
	if use x86; then
		echo 'arch=ia32'
	elif use amd64; then
		echo 'arch=x64'
	elif use arm; then
		echo 'arch=arm'
	fi
	if use debug; then
		echo 'mode=debug'
	else
		echo 'mode=release'
	fi
	if use debugger; then
		echo 'debuggersupport=on'
	else
		echo 'debuggersupport=off'
	fi
	if use disassembler; then
		echo 'disassembler=on'
	else
		echo 'disassembler=off'
	fi
	if use oprofile; then
		echo 'prof=oprofile'
	elif use profile; then
		echo 'prof=on'
	else
		echo 'prof=off'
	fi
	if use profiler; then
		echo 'profilingsupport=on'
	else
		echo 'profilingsupport=off'
	fi
	if use readline; then
		echo 'console=readline'
	else
		echo 'console=dumb'
	fi
		echo 'library=shared'
	if use samples; then
		echo 'sample=shell,process'
	fi
	if use snapshot; then
		if ! use profiler; then
			# profilingsupport, to be specific, seems to be needed for snapshot
			ewarn "Snapshot does not work without the profiler. Disabling snapshot."
			echo 'snapshot=off'
		else
		echo 'snapshot=on'
		fi
	else
		echo 'snapshot=off'
	fi
		echo 'soname=on'
	if use v8hiddenvisibility; then
		echo 'visibility=hidden'
	else
		echo 'visibility=default'
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}_enable_soname.patch"
	epatch "${FILESDIR}/${P}_install_target.patch"
	sed -i 's:_g::' "${S}/SConstruct"
}

src_compile() {
	local targets=library
	if use d8; then
		targets="$targets d8"
	fi
	if use samples; then
		targets="$targets sample"
	fi
	scons \
		$(myParams) \
		${targets} \
		|| die 'scons failed'
}

src_install() {
	scons \
		$(myParams) \
		DESTDIR="${D}" \
		install \
		|| die 'scons install failed'
	
	local soname="${myPN}.so.${PV}"
	mv "${D}/usr/lib/${myPN}.so"{,.${PV}}
	
	dosym "$soname" "/usr/lib/${myPN}.so"
	dosym "$soname" "/usr/lib/${myPN}.so.${SLOT}"
	
	if use d8; then
		dobin d8
	fi
	if use samples; then
		for sample in process shell; do
			newbin "$sample" "v8$sample"
		done
	fi
}
