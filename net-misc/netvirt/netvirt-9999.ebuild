# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils autotools git-r3 systemd

DESCRIPTION="NetVirt is an open source network virtualization platform (NVP)"
HOMEPAGE="http://netvirt.org"
EGIT_REPO_URI="https://github.com/netvirt/netvirt.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gui"

RDEPEND="sys-libs/libcap
		 gui? ( dev-qt/qtgui:4
			   dev-qt/qtdeclarative:4 )"
DEPEND="${RDEPEND}
	 	dev-util/scons
		dev-util/cmake"

src_configure() {
	cd libconfig
	econf
	cd ..
	local mycmakeargs=("-DWITH_GUI=$(usex gui)")
	cmake-utils_src_configure
}

src_compile() {
	cd udt4
	emake
	cd ..
	cd libconfig
	emake
	cd ..
	cd tapcfg
	mkdir release
	scons --force-32bit
	mv build/libtapcfg.so release/libtapcfg32.so
	strip release/libtapcfg32.so
	rm -rf build
	scons --force-64bit
	mv build/libtapcfg.so release/libtapcfg64.so
	strip release/libtapcfg64.so
	cd ..
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	systemd_newunit "${FILESDIR}"/netvirt-agent.service netvirt-agent.service
}
