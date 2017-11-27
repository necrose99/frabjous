# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

KNOT_MODULES=(
	+module-dnsproxy module-dnstap +module-noudp
	+module-onlinesign module-rosedb +module-rrl
	+module-stats +module-synthrecord +module-whoami
)

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="caps +daemon doc +fastparser idn libidn2 ${KNOT_MODULES[@]} static-libs systemd +utils"

RDEPEND=">=net-libs/gnutls-3.3:=
	>=dev-db/lmdb-0.9.15
	>=dev-libs/userspace-rcu-0.5.4
	dev-libs/libedit
	caps? ( >=sys-libs/libcap-ng-0.6.4 )
	daemon? ( dev-python/lmdb )
	module-dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c
	)
	idn? (
		!libidn2? ( net-dns/libidn )
		libidn2? ( >=net-dns/libidn2-2 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

for X in "${KNOT_MODULES[@]#+}"; do
	REQUIRED_USE+="${X}? ( daemon ) "
done

REQUIRED_USE+="caps? ( daemon ) idn? ( daemon )
	systemd? ( daemon )"

pkg_setup() {
	if use daemon; then
		enewgroup knot 53
		enewuser knot 53 -1 /var/lib/knot knot
	fi
}

src_configure() {
	local myconf X

	for X in "${KNOT_MODULES[@]#+}"; do
		myconf+=( --with-$X=$(usex $X 'shared' 'no') )
	done

	use daemon && myconf+=(
		--with-storage="${EPREFIX}"/var/lib/knot
		--with-rundir="${EPREFIX}"/var/run/knot
	)

	econf \
		--enable-systemd=$(usex systemd) \
		$(use_enable daemon) \
		$(use_enable fastparser) \
		$(use_enable module-dnstap dnstap) \
		$(use_enable doc documentation) \
		$(use_enable static-libs static) \
		$(use_enable utils utilities) \
		$(use_with idn libidn) \
		"${myconf[@]}" || die "econf failed"
}

src_compile() {
	default

	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )
	fi
}

src_install() {
	default

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service
		systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

		rmdir "${D%/}"/var/run/knot "${D%/}"/var/run/ || die
		diropts -o knot -g knot -m750
		dodir /var/lib/knot
	fi
}
