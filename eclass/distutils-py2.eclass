# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: distutils-py2.eclass
# Hijacks distutils-r1 to make it py2-compatible

_PYTHON_ALLOW_PY27=1

: ${DISTUTILS_USE_SETUPTOOLS:=bdepend}

if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
	inherit python-r1
else
	inherit python-single-r1
fi

_distutils_py2_set_globals() {
	local rdep bdep
	local setuptools_dep='
		|| ( >=dev-python/setuptools-py2-42.0.2[${PYTHON_USEDEP}] >=dev-python/setuptools-42.0.2[${PYTHON_USEDEP}] )
	'

	case ${DISTUTILS_USE_SETUPTOOLS} in
		no|manual)
			;;
		bdepend)
			bdep+=" ${setuptools_dep}"
			;;
		rdepend)
			bdep+=" ${setuptools_dep}"
			rdep+=" ${setuptools_dep}"
			;;
		pyproject.toml)
			bdep+=' dev-python/pyproject2setuppy[${PYTHON_USEDEP}]'
			;;
		*)
			die "Invalid DISTUTILS_USE_SETUPTOOLS=${DISTUTILS_USE_SETUPTOOLS}"
			;;
	esac

	if [[ ! ${DISTUTILS_SINGLE_IMPL} ]]; then
		bdep=${bdep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
		rdep=${rdep//\$\{PYTHON_USEDEP\}/${PYTHON_USEDEP}}
	else
		[[ -n ${bdep} ]] && bdep="$(python_gen_cond_dep "${bdep}")"
		[[ -n ${rdep} ]] && rdep="$(python_gen_cond_dep "${rdep}")"
	fi

	RDEPEND="${PYTHON_DEPS} ${rdep}"
	if [[ ${EAPI} != [56] ]]; then
		BDEPEND="${PYTHON_DEPS} ${bdep}"
	else
		DEPEND="${PYTHON_DEPS} ${bdep}"
	fi
	REQUIRED_USE=${PYTHON_REQUIRED_USE}
}
[[ ! ${DISTUTILS_OPTIONAL} ]] && _distutils_py2_set_globals
unset -f _distutils_py2_set_globals

DISTUTILS_USE_SETUPTOOLS=no
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
