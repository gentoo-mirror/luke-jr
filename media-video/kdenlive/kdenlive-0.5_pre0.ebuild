# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils kde

DESCRIPTION="Kdenlive! (pronounced Kay-den-live) is a Non Linear Video Editing Suite for KDE."
HOMEPAGE="http://kdenlive.sourceforge.net/"
SRC_URI="mirror://sourceforge/kdenlive/${P/_pre0/}-1.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="theora quicktime"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/libsamplerate
	media-libs/libogg
	media-libs/libvorbis
	media-sound/lame
	media-libs/libdv
	theora? ( >=media-libs/libtheora-1.0_alpha6 )
	quicktime? ( media-libs/libquicktime )
	media-video/ffmpeg
	>=media-libs/mlt-0.2.2
	>=media-libs/mlt++-20060601"

DEPEND="${RDEPEND}
	x11-base/xorg-server
	x11-proto/xextproto"

need-kde 3

pkg_setup() {
	if ! (  built_with_use media-libs/mlt sdl || \
			built_with_use media-video/ffmpeg sdl || \
			built_with_use media-libs/mlt X || \
			built_with_use media-video/ffmpeg X ); then
		eerror "You need to build both media-libs/mlt and media-video/ffmpeg"
		eerror "with USE 'sdl' and 'X' enabled."
		die "media-libs/mlt or media-video/ffmpeg w/o sdl/X detected"
	fi

	if use theora && ! built_with_use media-video/ffmpeg theora; then
		eerror "You need to build media-video/ffmpeg with USE 'theora' enabled."
		die "media-video/ffmpeg w/o theora detected"
	fi
}

src_compile() {
	rm configure
	myconf="--enable-pch"
	kde_src_compile
}
