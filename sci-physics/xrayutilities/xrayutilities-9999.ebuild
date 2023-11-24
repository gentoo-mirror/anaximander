# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..12} )

inherit distutils-r1 git-r3

DESCRIPTION="package with useful scripts for X-ray diffraction physicists"
HOMEPAGE="http://xrayutilities.sourceforce.io"
EGIT_REPO_URI="https://github.com/dkriegner/xrayutilities.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="openmp test"

RDEPEND=">=dev-python/numpy-1.9
	>=dev-python/scipy-0.13.0
	dev-python/h5py"
DEPEND="${RDEPEND}
	>sys-devel/gcc-4.2:*[openmp?]
	test? ( dev-python/pytest )"

DOCS=( README.md CHANGES.txt )

python_configure_all() {
	if ! use openmp; then
		mydistutilsargs=( --without-openmp )
	fi
}

python_test() {
	py.test -v
}
