# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{2_7,3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="package with useful scripts for X-ray diffraction physicists"
HOMEPAGE="http://xrayutilities.sourceforge.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp test"

DEPEND=">=dev-python/numpy-1.9
	>=dev-python/scipy-0.13.0
	dev-python/h5py
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>sys-devel/gcc-4.2:*[openmp?]"

DOCS=( README.md CHANGES.txt xrayutilities.pdf )

python_configure_all() {
	if ! use openmp; then
		mydistutilsargs=( --without-openmp )
	fi
}

python_test() {
	$PYTHON setup.py test || die
}
