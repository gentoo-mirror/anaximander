# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fdo-mime eutils

DESCRIPTION="Gnome application to organise documents or references, and to generate BibTeX bibliography files"
HOMEPAGE="http://icculus.org/referencer/"
SRC_URI="https://launchpad.net/${PN}/1./${PV}/+download/$P.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-text/poppler-0.12.3-r3
	>=dev-cpp/gtkmm-2.8
	>=dev-cpp/libglademm-2.6.0
	>=dev-cpp/gconfmm-2.14.0
	>=dev-cpp/gtkmm-utils-0.4.1
	dev-libs/boost
	dev-lang/python"

DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.3.2
	virtual/pkgconfig
	>=dev-lang/perl-5.8.1
	dev-perl/libxml-perl
	dev-util/intltool
	app-text/rarian"


src_prepare () {
	epatch "${FILESDIR}/${PN}-desktop-file-validate.patch"
}

src_configure() {
	econf --disable-update-mime-database --enable-python
}

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
