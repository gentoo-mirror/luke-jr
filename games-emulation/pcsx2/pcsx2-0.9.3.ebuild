CN=pcsx2
TOPDIR=/
inherit autotools pcsx2-0.9.3

IUSE="alsa debug dvd iso no-recbuild oss sse2"

RDEPEND="sys-libs/zlib
	dvd? ( =games-emulation/ps2emu-cdvd-linuz-0.4 )
	iso? ( || (
		=games-emulation/ps2emu-cdvd-iso-0.5
		=games-emulation/ps2emu-cdvd-isoefp-0.6
	) )
	|| (
		=games-emulation/ps2emu-cdvd-isoefp-0.6
		=games-emulation/ps2emu-cdvd-iso-0.5
		=games-emulation/ps2emu-cdvd-linuz-0.4
		=games-emulation/ps2emu-cdvd-null-0.3
	)
		=games-emulation/ps2emu-gs-zero-0.6
	|| (
		=games-emulation/ps2emu-pad-win-1.0
		=games-emulation/ps2emu-pad-zero-0.2.1
	)
	alsa? ( =games-emulation/ps2emu-spu2-peops-1.6 )
	oss? ( =games-emulation/ps2emu-spu2-peops-1.6 )
	|| (
		=games-emulation/ps2emu-spu2-null-0.4
		=games-emulation/ps2emu-spu2-peops-1.6
	)
		=games-emulation/ps2emu-dev9-null-0.3
		=games-emulation/ps2emu-usb-null-0.4
		=games-emulation/ps2emu-fw-null-0.3
"

src_compile() {
	pcsx2_prepcompile $(use_enable debug) --enable-devbuild $(use_enable \!no-recbuild recbuild) $(use_enable sse2)
	eautoreconf
	# non-devbuild is broken
	econf ${PCSX2OPTIONS} || die 'conf failed'
	emake all || die 'make failed'
}

src_install() {
	emake DESTDIR="${D}" install || die 'install failed'
}