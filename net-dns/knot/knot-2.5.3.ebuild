# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic systemd user

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caps +daemon dnstap doc +fastparser idn static-libs systemd +utils"

RDEPEND=">=net-libs/gnutls-3.3:=
	>=dev-db/lmdb-0.9.15
	>=dev-libs/userspace-rcu-0.5.4
	dev-libs/libedit
	caps? ( >=sys-libs/libcap-ng-0.6.4 )
	daemon? ( dev-python/lmdb )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c
	)
	idn? (
		|| (
			>=net-dns/libidn2-2.0.0
			net-dns/libidn
		)
	)
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"
REQUIRED_USE="
	caps? ( daemon )
	dnstap? ( daemon )
	idn? ( daemon )
	systemd? ( daemon )"

pkg_setup() {
	if use daemon; then
		enewgroup knot 53
		enewuser knot 53 -1 /var/lib/knot knot
	fi
}

src_configure() {
	local myconf=( --with-lmdb )
	use daemon && myconf+=(
		--with-storage="${EPREFIX}"/var/lib/${PN}
		--with-rundir="${EPREFIX}"/var/run/${PN}
	)
	econf \
		"${myconf[@]}" \
		$(use_enable daemon) \
		$(use_enable fastparser) \
		$(use_enable dnstap) \
		$(use_with dnstap module-dnstap) \
		$(use_enable doc documentation) \
		$(use_with idn libidn) \
		$(use_enable static-libs static) \
		$(use_enable utils utilities) \
		--enable-systemd=$(usex systemd) \
		|| die "econf failed"
}

src_compile() {
	default

	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )
	fi
}

src_test() {
	emake check
}

src_install() {
	default

	if use daemon; then
		keepdir /var/lib/${PN}

		newinitd "${FILESDIR}"/knot.initd-r1 knot
		systemd_dounit "${FILESDIR}"/knot.service
		systemd_newtmpfilesd "${FILESDIR}"/knot.tmpfilesd knot.conf
	fi
}
