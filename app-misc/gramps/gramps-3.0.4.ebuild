# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="1"

NEED_PYTHON="2.5"
WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools eutils gnome2 python

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="http://www.gramps-project.org/"
SRC_URI="mirror://sourceforge/gramps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cdr gnome reports"

GNOME_RDEPEND="
	|| ( dev-python/libgnome-python
		>=dev-python/gnome-python-2.22.0
		>=dev-python/gnome-python-desktop-2.6 )
"
RDEPEND=">=dev-python/pygtk-2.10.0
	dev-lang/python[berkdb,sqlite]                                         
	cdr? ( $GNOME_RDEP )                                                   
	gnome? ( $GNOME_RDEP )                                                 
	reports? ( media-gfx/graphviz )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/libiconv
	dev-util/pkgconfig
	app-text/gnome-doc-utils"

DOCS="NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-mime-install"
}

src_unpack() {
	gnome2_src_unpack
	epatch "${FILESDIR}"/${PN}-3.0.3_fix-installation-race-condition.patch
	epatch "${FILESDIR}"/${PN}-3.0.3_make-gnome-optional.patch
	eautoreconf
	# This is for bug 215944, so .pyo/.pyc files don't get into the
	# file system
	mv "${S}"/py-compile "${S}"/py-compile.orig
	ln -s $(type -P true) "${S}"/py-compile
}

src_install() {
	python_need_rebuild
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/share/${PN}
}
