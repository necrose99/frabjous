# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic user

DESCRIPTION="A caching full DNS resolver implementation written in C and LuaJIT"
HOMEPAGE="https://www.knot-resolver.cz"
SRC_URI="https://secure.nic.cz/files/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dnstap go pie memcached redis test"

RDEPEND=">=net-dns/knot-2.3.1
	>=dev-libs/libuv-1.7.0
	dev-lang/luajit:2
	dev-lua/luasocket
	dev-lua/luasec
	dnstap? (
		>=dev-libs/protobuf-3.0
		dev-libs/protobuf-c
		dev-libs/fstrm
	)
	go? ( >=dev-lang/go-1.5.0 )
	memcached? ( dev-libs/libmemcached )
	redis? ( >=dev-libs/hiredis-0.11.0 )"
DEPEND="${RDEPEND}
	!>=net-dns/knot-2.6.0
	virtual/pkgconfig
	test? (
		dev-util/cmocka
		dnstap? ( >=dev-lang/go-1.5.0 )
	)"
RESTRICT="mirror"

pkg_setup() {
	enewgroup kresd
	enewuser kresd -1 -1 /var/lib/knot-resolver kresd
}

src_prepare() {
	# Gentoo has FORTIFY_SOURCE enabled by default
	sed -i 's/ -D_FORTIFY_SOURCE=2//g' \
		./config.mk || die

	default
}

src_compile() {
	append-cflags -DNDEBUG
	emake \
		LDFLAGS="${LDFLAGS}" \
		PREFIX="${EPREFIX}"/usr \
		ETCDIR="${EPREFIX}"/etc/knot-resolver \
		ENABLE_DNSTAP=$(usex dnstap) \
		HARDENING=$(usex pie) \
		HAS_cmocka=$(usex test) \
		HAS_go=$(usex go) \
		HAS_hiredis=$(usex redis) \
		HAS_libmemcached=$(usex memcached) \
		HAS_libsystemd=no
}

src_test() {
	emake check
	use dnstap && emake ckeck-dnstap
}

src_install() {
	emake \
		PREFIX=/usr \
		ETCDIR=/etc/kresd \
		LIBDIR="$(get_libdir)" \
		DESTDIR="${D}" install

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /var/lib/knot-resolver
	doins "${FILESDIR}"/root.keys
	fowners kresd:kresd /var/lib/knot-resolver/root.keys

	insinto /etc/knot-resolver
	newins "${FILESDIR}"/${PN}.config config

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if [ -z "${REPLACING_VERSIONS}" ]; then
		einfo
		elog "If you prefer not to use the bundled root.keys, just delete"
		elog "'${EROOT%/}/var/lib/knot-resolver/root.keys', then start ${PN}."
		elog "The bootstrapping of the keys is automated, and kresd fetches"
		elog "root trust anchors set over a secure channel from IANA."
		elog "From there, it can perform automatic updates for you."
		einfo
	fi
}
