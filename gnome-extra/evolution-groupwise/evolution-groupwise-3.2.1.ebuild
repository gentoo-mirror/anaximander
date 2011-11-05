# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Evolution module for connecting to Novell Groupwise"
HOMEPAGE="http://www.gnome.org/projects/evolution/"

LICENSE="LGPL-2"

KEYWORDS="~amd64 ~x86"

IUSE="nls doc"
SLOT="2"

RDEPEND="
	>=mail-client/evolution-$PV
	>=gnome-extra/evolution-data-server-$PV
	>=x11-libs/gtk+-3.0:3
	nls? ( sys-devel/gettext )
	>=net-libs/libsoup-2.3
	>=dev-libs/libxml2-2.0
	>=gnome-base/gconf-2:2
	>=dev-libs/glib-2.16
	sys-libs/db"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-mode
		$(use_enable nls)"
	DOCS="AUTHORS ChangeLog NEWS README"
}
