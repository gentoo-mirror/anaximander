# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit eutils scons-utils distutils git-2

DESCRIPTION="package with useful scripts for X-ray diffraction physicists"
HOMEPAGE="http://sourceforge.net/projects/xrayutilities"
EGIT_REPO_URI="git://git.code.sf.net/p/xrayutilities/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/numpy
        sci-libs/scipy
        dev-python/pytables
		app-text/texlive
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-mathextra
		dev-texlive/texlive-science"
RDEPEND="${DEPEND}"

src_prepare() {
    epatch "${FILESDIR}"/remove_python_package_install_from_scons.patch
}

src_compile() {
    escons
}

src_install() {
    # install c-library using patched SConstruct
    escons DESTDIR="${D}" install
	# install python package to system python folder
    distutils_src_install
}
