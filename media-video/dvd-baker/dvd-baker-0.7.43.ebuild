DESCRIPTION="dvd-baker is an application designed to turn your image collection into a DVD."
HOMEPAGE="http://dvd-baker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}-1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#maybe later: IUSE="gallery20 gallery21"

RDEPEND="
	>=media-video/dvd-slideshow-0.7.3
	>=media-gfx/imagemagick-6.0.6
	>=app-shells/bash-2.05
	>=sys-process/lsof-4.74
"

src_install() {
	local PFX="${D}/usr"
	mkdir -p "${PFX}/usr"
	PATH="${PATH}:${PFX}/bin" \
	./install.sh "${PFX}" || die "install failed"
}
