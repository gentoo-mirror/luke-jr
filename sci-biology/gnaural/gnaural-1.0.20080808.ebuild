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

export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${FILESDIR}"

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
}
