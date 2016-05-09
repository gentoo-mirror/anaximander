# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils vcs-snapshot user systemd

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~s390 ~sh ~sparc ~x86"
IUSE="dbus +seccomp static-libs"

DEPEND="dev-libs/openssl:*
	dev-libs/libevent
	dbus? ( sys-apps/dbus )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Use the system cert store rather than a custom one specific
	# to the tlsdate package. #534394
	sed -i \
		-e 's:/tlsdate/ca-roots/tlsdate-ca-roots.conf:/ssl/certs/ca-certificates.crt:' \
		Makefile.am || die
	epatch "${FILESDIR}/tlsdate-0.0.13-tlsdated-service.patch"

	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		$(use_enable dbus) \
		$(use_enable seccomp seccomp-filter) \
		--disable-hardened-checks \
		--without-polarssl \
		--with-unpriv-user=tlsdate \
		--with-unpriv-group=tlsdate
}

src_install() {
	default

	# Use Google servers by default rather than a random German site.
	# They provide round robin DNS and local servers automatically.
	sed -i \
		-e 's:www.ptb.de:www.google.com:' \
		"${ED}"/etc/tlsdate/tlsdated.conf || die

	# Use the system cert store; see src_prepare. #446426 #534394
	rm "${ED}"/etc/tlsdate/ca-roots/tlsdate-ca-roots.conf || die
	rmdir "${ED}"/etc/tlsdate/ca-roots || die

	newinitd "${FILESDIR}"/tlsdated.rc tlsdated
	newconfd "${FILESDIR}"/tlsdated.confd tlsdated
	newinitd "${FILESDIR}"/tlsdate.rc tlsdate
	newconfd "${FILESDIR}"/tlsdate.confd tlsdate

	systemd_newunit "${S}"/systemd/tlsdated.service tlsdated.service
	systemd_newtmpfilesd "${FILESDIR}"/tlsdated.tmpfiles.conf tlsdated.conf
	insinto /etc/default
	newins "${FILESDIR}"/tlsdated.default tlsdated

	insinto /etc/dbus-1/system.d/
	doins dbus/org.torproject.tlsdate.conf

	use static-libs || \
		find "${ED}"/usr '(' -name '*.la' -o -name '*.a' ')' -delete
}

pkg_preinst() {
	enewgroup tlsdate 124
	enewuser tlsdate 124 -1 /dev/null tlsdate
}