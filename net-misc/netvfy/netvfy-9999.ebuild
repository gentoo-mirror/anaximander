# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 systemd

DESCRIPTION="create your own secure virtual network"
HOMEPAGE="http://doc.netvfy.com"
EGIT_REPO_URI="https://github.com/netvfy/netvfy-agent.git"
EGIT_SUBMODULES=( '*' '-libconfig' )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libconfig
		dev-libs/openssl:=
		dev-libs/jansson
		dev-libs/libevent
		net-nds/openldap
		net-misc/curl[ssl]
		sys-libs/zlib
		sys-libs/glibc"
DEPEND="${RDEPEND}
		dev-util/scons
		dev-util/cmake"

src_configure() {
	local mycmakeargs=( -DWITH_GUI=no )
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
	systemd_newunit "${FILESDIR}/netvfy-agent.service" netvfy-agent.service
	systemd_install_serviced "${FILESDIR}/netvfy-agent.service.conf"
	newinitd "${FILESDIR}/netvfy-agent.rc" netvfy-agent
	newconfd "${FILESDIR}/netvfy-agent.conf" netvfy-agent
}

pkg_postinst() {
	elog "Read https://doc.netvfy.com to get started. In particular"
	elog "you will have to provision a network using netvfy-agent -k ... and"
	elog "edit the config file /etc/conf.d/netvfy-agent (OpenRC) or the"
	elog "settings in /etc/systemd/system/netvfy-agent.service.d/ (systemd)"
	elog "and enable the corresponding netvfy-agent service"
}
