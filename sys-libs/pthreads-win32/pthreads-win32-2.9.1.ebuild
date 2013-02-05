
# Originally by Nathan Brink <ohnobinki@ohnopublishing.net>, 2008
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Provides the pthreads API on windows"
HOMEPAGE="http://sourceware.org/pthreads-win32/"
SRC_URI="ftp://sourceware.org/pub/pthreads-win32/pthreads-w32-2-8-0-release.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

#This is commented because, even w32api is installed into my /usr/mingw32 sysroot, crossdev didn't automatically add the package to /usr/mingw32/etc/portage/profile/package.provided
#RDEPEND="dev-util/w32api"
DEPEND=""
PDEPEND=""

src_compile() {
	#cd "pthreads-w32-${PV}-release"
	#cd "pthreads-w32-2-8-0-release"
	cd pthreads-w32-*-release
	emake CROSS="${CHOST}-" clean GC-inlined || die "emake failed"
}

src_install() {
	mkdir -p "${D}"usr/include "${D}"usr/bin "${D}"usr/lib && \
		cd pthreads-w32-*-release && \
		cp pthread.h sched.h semaphore.h "${D}"usr/include/ && \
		cp pthreadGC2.dll "${D}"usr/bin/ && \
		cp libpthreadGC2.a "${D}"usr/lib/ && \
		dosym pthreadGC2.dll /usr/bin/pthread.dll && \
		dosym libpthreadGC2.a /usr/lib/libpthread.a || \
		die "install failed"
	dodoc COPYING COPYING.LIB PROGRESS MAINTAINERS NEWS ANNOUNCE BUGS ChangeLog CONTRIBUTORS WinCE-PORT README*
}
