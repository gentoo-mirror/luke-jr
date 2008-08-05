inherit distutils

DESCRIPTION="open source document analysis and OCR system"
HOMEPAGE="http://www.ocropus.org"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aspell leptonica libedit lua python sdl"
DEPEND="
	|| ( dev-util/jam dev-util/ftjam )
	media-libs/libpng:1.2
	media-libs/jpeg
	media-libs/tiff
	>app-text/tesseract-2.00
	aspell? ( app-text/aspell )
	lua? (
		sdl? (
			media-libs/libsdl
			media-libs/sdl-gfx
			media-libs/sdl-image
		)
		libedit? ( dev-libs/libedit )
		leptonica? (
			media-gfx/leptonica
		)
	)
	python? (
		dev-python/numpy
	)
"
RDEPEND="${DEPEND}"

src_compile() {
	local CXXFLAGS_extra
	use python &&
		CXXFLAGS_extra="-fPIC"
	CXXFLAGS="$CXXFLAGS $CXXFLAGS_extra" \
	econf \
		--with-tesseract=/usr \
		$(use_with aspell) \
		$(use_with lua ocroscript) \
		$(use_with leptonica laptonica) \
		$(use_with sdl SDL) \
		|| die "econf failed"
	jam -q || die "jam failed"
	if use python; then
		einfo 'Building Python extension...'
		cd python-binding
		distutils_python_version
		echo sed -i 's:^\(subdirs_from_here = [\)\(.*\)$:\1'"'${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/numpy/core/include/'"', (\2):' setup.py
		bash
		distutils_src_compile
	fi
}

src_install() {
	sed -i 's,^\(INSTALL_DIR = \).*$,\1'"${D}/bin ;," Jamfile
	jam -q install || die "jam install failed"
	if use python; then
		einfo 'Installing Python extension...'
		cd python-binding
		distutils_src_install
	fi
}
