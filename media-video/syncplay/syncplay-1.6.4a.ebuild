# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 python3_7 )

inherit python-r1

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+client +server vlc"
REQUIRED_USE="vlc? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
	vlc? ( media-video/vlc[lua] )"

src_prepare() {
	sed -i 's/"noGui": False,/"noGui": True,/' \
		syncplay/ui/ConfigurationGetter.py \
		|| die "Failed to patch ConfigurationGetter.py"
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

pkg_postinst() {
	if use client; then
		einfo "Syncplay supports the following players:"
		einfo "media-video/mpv, media-video/mplayer2, media-video/vlc"
	fi
}
