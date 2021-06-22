
# Originally by Nathan Brink <ohnobinki@ohnopublishing.net>, 2008
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Provides the pthreads API on windows"
HOMEPAGE="http://sourceware.org/pthreads-win32/"
SRC_URI="ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-9-1-release.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

#This is commented because, even w32api is installed into my /usr/mingw32 sysroot, crossdev didn't automatically add the package to /usr/mingw32/etc/portage/profile/package.provided
#RDEPEND="dev-util/w32api"
DEPEND=""
PDEPEND=""

CHOST=x86_64-w64-mingw32

S="${WORKDIR}/pthreads-w32-${PV//./-}-release"

src_compile() {
	emake CROSS="${CHOST}-" clean GC-inlined || die "emake failed"
}

src_install() {
	doheader pthread.h sched.h semaphore.h
	dolib.so pthreadGC2.dll
	dolib.a libpthreadGC2.a
	dosym pthreadGC2.dll "/usr/$(get_libdir)/pthread.dll"
	dosym libpthreadGC2.a "/usr/$(get_libdir)/libpthread.a"
	dodoc COPYING COPYING.LIB PROGRESS MAINTAINERS NEWS ANNOUNCE BUGS ChangeLog CONTRIBUTORS WinCE-PORT README*
}
