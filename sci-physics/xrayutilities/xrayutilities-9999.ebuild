# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
EGIT_REPO_URI="git://git.code.sf.net/p/xrayutilities/code"

inherit distutils-r1 git-2 eutils

DESCRIPTION="package with useful scripts for X-ray diffraction physicists"
HOMEPAGE="http://sourceforge.net/projects/xrayutilities"
EGIT_REPO_URI="git://git.code.sf.net/p/xrayutilities/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="openmp test"

DEPEND="dev-python/numpy
	sci-libs/scipy
	dev-python/h5py
	>sys-devel/gcc-4.2:*[openmp?]"
RDEPEND="${DEPEND}"

DOCS=( README.txt CHANGES.txt xrayutilities.pdf )
EXAMPLES=( examples/. )

python_configure_all() {
	if ! use openmp; then
		mydistutilsargs=( --without-openmp )
	fi
}

python_test() {
	cd xrayutilities/tests
	$PYTHON -m unittest discover || die
}
