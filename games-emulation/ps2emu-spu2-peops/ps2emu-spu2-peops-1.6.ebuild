CN=spu2/PeopsSPU2
inherit pcsx2-0.9.3

IUSE="alsa oss threads"

src_compile() {
	pcsx2_prepcompile
	local alsa=TRUE nothread=FALSE
	use oss && ! use alsa && alsa=FALSE
	use threads || nothread=TRUE
	make USEALSA=${alsa} NOTHREADLIB=${nothread} all
}
