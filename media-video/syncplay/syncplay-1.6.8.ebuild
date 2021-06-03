# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 python3_7 python3_8 )

inherit python-r1 xdg-utils

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# + BSD for GUI stuff; + CC-BY-2.5 CC-BY-3.0 for icons
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 ~x86"
IUSE="+client +server vlc"
REQUIRED_USE="vlc? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
	vlc? ( >=media-video/vlc-2.2.1[lua] )"

src_prepare() {
	sed -i 's/"noGui": False,/"noGui": True,/' \
		syncplay/ui/ConfigurationGetter.py \
		|| die "Failed to patch ConfigurationGetter.py"

	# Exclude unused files under other licenses
	rm -r syncplay/vendor/{?t*.py,darkdetect} syncplay/resources/*.png || die 'Failed to delete GUI files'
	sed -i '
		/resources\/\*\.png/d;
		s/gzip \(.*\) --stdout\( > $(SHARE_PATH)\/man\/man1\/.*\)\.gz$/cat \1\2/
	' \
		GNUmakefile || die 'Failed to patch GNUmakefile'

	default
}

src_compile() {
	:
}

src_install() {
	local MY_MAKEOPTS=( DESTDIR="${D}" PREFIX=/usr )
	use client && \
		emake "${MY_MAKEOPTS[@]}" VLC_SUPPORT=$(usex vlc true false) install-client
	use server && \
		emake "${MY_MAKEOPTS[@]}" install-server
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	if use client; then
		einfo "Syncplay supports the following players:"
		einfo "media-video/mpv, media-video/mplayer2, media-video/vlc"
	fi
}
