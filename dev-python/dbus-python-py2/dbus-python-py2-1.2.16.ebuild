# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
_PYTHON_ALLOW_PY27=1
PYTHON_REQ_USE="threads(+)"
MY_PN="${PN/-py2/}"
MY_P="${MY_PN}-${PV}"

inherit autotools python-r1

DESCRIPTION="Python2 bindings for the D-Bus messagebus"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/DBusBindings https://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="https://dbus.freedesktop.org/releases/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

IUSE="doc examples test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

DEPEND="${PYTHON_DEPS}
	!!dev-python/dbus-python[python_targets_python2_7(-)]
	>=sys-apps/dbus-1.8:=
	>=dev-libs/glib-2.40
"
RDEPEND="${DEPEND}
	~dev-python/dbus-python-${PV}
"
BDEPEND="
	virtual/pkgconfig
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )
	test? ( dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/tappy[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

python_check_deps() {
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_prepare() {
	default
	python_copy_sources
}

src_configure() {
	use doc && python_setup
	local SPHINX_IMPL=${EPYTHON}

	configuring() {
		local myconf=(
			--disable-documentation
		)
		[[ ${EPYTHON} == ${SPHINX_IMPL} ]] &&
			myconf+=( --enable-documentation )

		econf "${myconf[@]}"
	}
	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	find "${D}" -name '*.la' -type f -delete || die

	use examples && dodoc -r examples

	# provided by py3 dbus-python
	rm "${D}/usr/lib64/pkgconfig/dbus-python.pc" "${D}/usr/include/dbus-1.0/dbus/dbus-python.h" || die
}
