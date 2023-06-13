# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )

inherit python-r1 xdg-utils

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# + BSD for GUI stuff; + CC-BY-2.5 CC-BY-3.0 for icons
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="+client +server vlc"
REQUIRED_USE="vlc? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-16.4.0[ssl,${PYTHON_USEDEP}]
		>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
	)
	vlc? ( >=media-video/vlc-2.2.1[lua] )"

src_prepare() {
	eapply "${FILESDIR}/${PN}-no-pem.patch"

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
	if use client; then
		emake "${MY_MAKEOPTS[@]}" VLC_SUPPORT=$(usex vlc true false) install-client
		python_replicate_script "${ED}/usr/bin/syncplay"
	fi
	if use server; then
		emake "${MY_MAKEOPTS[@]}" install-server
		python_replicate_script "${ED}/usr/bin/syncplay-server"
	fi
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
