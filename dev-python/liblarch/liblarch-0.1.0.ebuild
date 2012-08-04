# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit distutils

DESCRIPTION="a library to handle directed acyclic graphs"
HOMEPAGE="http://live.gnome.org/liblarch"
SRC_URI="http://gtg.fritalk.com/publique/gtg.fritalk.com/${PN}/${PV:0:3}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/pygobject:2"
RDEPEND="${DEPEND}"
