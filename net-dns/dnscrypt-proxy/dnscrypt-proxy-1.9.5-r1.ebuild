# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

MINISIGN_PK="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"
DESCRIPTION="A tool for securing communications between a client and a DNS resolver"
HOMEPAGE="https://dnscrypt.org"
SRC_URI="https://download.dnscrypt.org/${PN}/${P}.tar.gz
	verify-minisign? ( https://download.dnscrypt.org/${PN}/${P}.tar.gz.minisig )"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="hardened libressl +plugins ssl systemd verify-minisign"

RDEPEND="
	dev-libs/libsodium
	net-libs/ldns
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	verify-minisign? ( app-crypt/minisign )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog NEWS README.markdown DNSCRYPT-V2-PROTOCOL.txt )

pkg_setup() {
	if use verify-minisign; then
	minisign -VP ${MINISIGN_PK} -m "${DISTDIR}"/${P}.tar.gz \
		|| die "Minisign verification failed!"
	fi

	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_configure() {
	econf \
		$(use_enable hardened pie) \
		$(use_enable plugins) \
		$(use_enable ssl openssl) \
		$(use_with systemd)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_dounit "${FILESDIR}"/${PN}.socket

	insinto /etc
	doins "${FILESDIR}"/${PN}.conf
}

pkg_preinst() {
	# ship working default configuration for systemd users
	if use systemd; then
		sed -i 's/Daemonize yes/Daemonize no/g' "${D}"/etc/${PN}.conf
	fi
}

pkg_postinst() {
	elog
	elog "After starting the service you will need to update your"
	elog "${EROOT}etc/resolv.conf and replace your current set of resolvers with:"
	elog
	elog "nameserver 127.0.0.1"
	if use systemd; then
		elog
		elog "with systemd dnscrypt-proxy ignores LocalAddress setting in the config file"
		elog "edit dnscrypt-proxy.socket if you need to change the defaults"
	fi
	elog
	elog "Also see https://github.com/jedisct1/dnscrypt-proxy#usage."
	elog
}
