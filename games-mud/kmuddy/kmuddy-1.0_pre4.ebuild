EAPI="2"

KDE_MINIMAL="4.0"
KDE_LINGUAS="es"

inherit kde4-base

MyP="${P/_/}"

DESCRIPTION="MUD client for KDE"
HOMEPAGE="http://www.kmuddy.com/"
SRC_URI="http://www.kmuddy.com/releases/devel/${MyP}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ~ppc x86"
IUSE="${IUSE} mxp"

DEPEND="
	mxp? ( net-libs/libmxp )
	!kdeprefix? ( !${CATEGORY}/${PN}:0 )"

RDEPEND="${DEPEND}
"

S="${WORKDIR}/${MyP}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_enable mxp WITH_MXP)
	"
	
	set -x
	
	kde4-base_src_configure
}
