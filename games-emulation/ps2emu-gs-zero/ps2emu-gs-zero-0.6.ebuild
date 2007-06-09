CN=gs/zerogs/opengl
inherit autotools pcsx2-0.9.3

RDEPEND="media-gfx/nvidia-cg-toolkit"

IUSE="sse2"

src_compile() {
	# buggy build.sh
	eautoreconf
	PCSX2PLUGINS="$(games_get_libdir)/pcsx2/plugins/"
	chmod +x configure
	egamesconf $(use_enable sse2) --prefix="${PCSX2PLUGINS}" || die 'configure failed'
	emake || die 'make failed'
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'
}