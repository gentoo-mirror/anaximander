# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gtg/gtg-0.2.5.ebuild,v 1.1 2012/01/28 21:16:06 steev Exp $

EAPI="4"

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] 3.* *-jython"

inherit eutils fdo-mime gnome2-utils distutils

DESCRIPTION="Personal organizer for the GNOME desktop environment"
HOMEPAGE="http://gtg.fritalk.com/"
SRC_URI="http://launchpad.net/${PN}/0.3/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/configobj
	dev-python/dbus-python
	dev-python/pycairo
	dev-python/pygobject:2
	dev-python/pygtk
	dev-python/pyxdg
	dev-python/simplejson
	dev-python/liblarch
	dev-python/liblarch-gtk"
DEPEND="${RDEPEND}"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	distutils_pkg_postrm

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
