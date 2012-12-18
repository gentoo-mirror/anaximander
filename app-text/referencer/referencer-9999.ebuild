# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2:2.7"

inherit fdo-mime bzr eutils python

DESCRIPTION="Gnome application to organise documents or references, and to generate BibTeX bibliography files"
HOMEPAGE="http://icculus.org/referencer/"
EBZR_REPO_URI="lp:~${PN}-devs/${PN}/trunk"
EBZR_BOOTSTRAP="autogen.sh"
EBZR_PATCHES="${FILESDIR}/${PN}-desktop-file-validate.patch"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi


RDEPEND=">=app-text/poppler-0.12.3-r3
	>=dev-cpp/gtkmm-2.8
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gconfmm-2.14.0
	>=dev-cpp/gtkmm-utils-0.4.1
	dev-libs/boost"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	virtual/pkgconfig
	>=dev-lang/perl-5.8.1
	dev-perl/libxml-perl
	dev-util/intltool
	app-text/rarian"

pkg_setup() {
	    python_set_active_version 2.7
		python_pkg_setup
}

src_prepare () {
	bzr_bootstrap
	python_convert_shebangs -r 2.7 plugins
}

src_configure() {
	econf --disable-update-mime-database --enable-python
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
