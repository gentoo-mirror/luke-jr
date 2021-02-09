# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: distutils-py2.eclass
# Hijacks distutils-r1 to make it py2-compatible

_PYTHON_ALLOW_PY27=1
inherit distutils-r1

# Python 2 didn't support parallel builds
distutils-py2_python_compile() {
	_distutils-r1_copy_egg_info
	esetup.py build "${@}"
}

distutils-py2_python_install() {
	addpredict "${EPREFIX}/usr/$(get_libdir)/${EPYTHON}"
	addpredict /usr/lib/pypy2.7
	distutils-r1_python_install
}

python_compile() { distutils-py2_python_compile; }
python_install() { distutils-py2_python_install; }
