# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 systemd

DESCRIPTION="NetVirt is an open source network virtualization platform (NVP)"
HOMEPAGE="http://netvirt.org"
EGIT_REPO_URI="https://github.com/netvirt/netvirt.git"
EGIT_SUBMODULES=( '*' '-libconfig' )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gui"

RDEPEND="sys-libs/libcap
		 dev-libs/libconfig
		 gui? ( dev-qt/qtgui:4
			   dev-qt/qtdeclarative:4 )"
DEPEND="${RDEPEND}
	 	dev-util/scons
		dev-util/cmake"

PATCHES=( "${FILESDIR}"/netvirt-system-libconfig.patch )

src_configure() {
	local mycmakeargs=( -DWITH_GUI=$(usex gui)
					    -DCMAKE_LIBRARY_PATH=/usr/$(get_libdir) )
	cmake-utils_src_configure
}

src_compile() {
	cd udt4
	emake
	cd ..
	cd tapcfg
	scons
	cd ..
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	systemd_newunit "${FILESDIR}"/netvirt-agent.service netvirt-agent.service
	newinitd "${FILESDIR}"/netvirt-agent.rc netvirt-agent
}
