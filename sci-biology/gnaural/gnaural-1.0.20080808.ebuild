inherit autotools

DESCRIPTION='A programmable binaural-beat generator, implementing the principle of binaural beats as described in the October 1973 Scientific American article "Auditory Beats in the Brain" (Gerald Oster).'
HOMEPAGE="http://gnaural.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>media-libs/portaudio-19_alpha0
	>=x11-libs/gtk+-2
	gnome-base/libglade
	>=dev-libs/glib-2
	>=media-libs/libsndfile-1.0.2
	>=media-libs/portaudio-19_alpha0
"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's: portaudio-2.0 >= 19::' configure.in
	WANT_AUTOCONF=2.5 \
	eautoconf || die 'autoconf failed'
}
