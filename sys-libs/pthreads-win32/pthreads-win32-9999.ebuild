
# Originally by Nathan Brink <ohnobinki@ohnopublishing.net>, 2008
# Distributed under the terms of the GNU General Public License v2

inherit eutils git-2

DESCRIPTION="Provides the pthreads API on windows"
HOMEPAGE="http://sourceforge.net/p/pthreads4w/"
EGIT_PROJECT="pthreads-win32"
EGIT_REPO_URI="git://git.code.sf.net/p/pthreads4w/code"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

#This is commented because, even w32api is installed into my /usr/mingw32 sysroot, crossdev didn't automatically add the package to /usr/mingw32/etc/portage/profile/package.provided
#RDEPEND="dev-util/w32api"
DEPEND=""
PDEPEND=""

src_compile() {
	local bits=32
	use amd64 && bits=64
	local OPTS=()
	OPTS+=(CROSS="${CHOST}-")
	OPTS+=(ARCH="-m$bits")
	emake "${OPTS[@]}" clean
	emake "${OPTS[@]}" pthread_getspecific.o
	emake "${OPTS[@]}" GC || die "emake failed"
}

src_install() {
	mkdir -p "${D}"usr/include "${D}"usr/bin "${D}"usr/lib && \
		cp pthread.h sched.h semaphore.h "${D}"usr/include/ && \
		cp pthreadGC2.dll "${D}"usr/bin/ && \
		cp libpthreadGC2.a "${D}"usr/lib/ && \
		dosym pthreadGC2.dll /usr/bin/pthread.dll && \
		dosym libpthreadGC2.a /usr/lib/libpthread.a || \
		die "install failed"
	dodoc COPYING COPYING.LIB PROGRESS MAINTAINERS NEWS ANNOUNCE BUGS ChangeLog CONTRIBUTORS WinCE-PORT README*
}
