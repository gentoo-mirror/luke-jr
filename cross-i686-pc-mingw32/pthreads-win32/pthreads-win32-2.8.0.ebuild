EAPI=4

DESCRIPTION=""
HOMEPAGE="http://sourceware.org/pthreads-win32/"
myPN="${PN/in/}"
myPV="${PV//./-}"
myP="${myPN}-${myPV}"
LICENSE="LGPL-2.1"

myINC="ftp://sourceware.org/pub/pthreads-win32/prebuilt-dll-${myPV}-release/include"
myLIB="ftp://sourceware.org/pub/pthreads-win32/prebuilt-dll-${myPV}-release/lib"
SRC_URI="
	${myINC}/pthread.h -> pthread-win32_pthread.h
	${myINC}/sched.h -> pthread-win32_sched.h
	${myINC}/semaphore.h -> pthread-win32_semaphore.h
	${myLIB}/libpthreadGC2.a -> pthread-win32_libpthreadGC2.a
"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# FIXME: actually build it :p

myARCH="${CATEGORY/cross-/}"

src_install() {
	insinto "/usr/${myARCH}/usr/include"
	for h in pthread.h sched.h semaphore.h; do
		newins "${DISTDIR}/pthread-win32_${h}" "${h}"
	done
	into "/usr/${myARCH}/usr"
	newlib.a "${DISTDIR}/pthread-win32_libpthreadGC2.a" "libpthread.a"
}
