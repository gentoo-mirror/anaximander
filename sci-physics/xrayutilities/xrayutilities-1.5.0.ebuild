# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{2_7,3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="package with useful scripts for X-ray diffraction physicists"
HOMEPAGE="http://xrayutilities.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp test"

DEPEND=">=dev-python/numpy-1.8
	>=sci-libs/scipy-0.13.0
	dev-python/h5py
	>sys-devel/gcc-4.2:*[openmp?]"
RDEPEND="${DEPEND}"

DOCS=( README.md CHANGES.txt xrayutilities.pdf )

python_configure_all() {
	if ! use openmp; then
		mydistutilsargs=( --without-openmp )
	fi
}

python_test() {
	$PYTHON setup.py test || die
}