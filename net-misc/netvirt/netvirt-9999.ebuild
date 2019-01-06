# Copyright 1999-2019 Gentoo Authors
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
		dev-libs/openssl:=
		dev-libs/jansson
		dev-libs/libevent
		net-nds/openldap
		net-misc/curl[ssl]
		sys-libs/zlib
		sys-libs/glibc
		gui? ( dev-qt/qtgui:4
			dev-qt/qtdeclarative:4 )"
DEPEND="${RDEPEND}
		dev-util/scons
		dev-util/cmake"

src_configure() {
	local mycmakeargs=( -DWITH_GUI=$(usex gui) )
	cmake-utils_src_configure
}

src_compile() {
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

pkg_postinst() {
	elog "Carefully read https://doc.dynvpn.com to get started. In particular"
	elog "you will have to provision a network using netvirt-agent2 -k ... and"
	elog "edit the init scripts to connect to the right network."
}
