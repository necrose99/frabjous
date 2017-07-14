# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/mholt/${PN}"
CADDYMAIN="${EGO_PN}/caddy/caddymain"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-libs/libcap"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -ldflags "-X ${CADDYMAIN}.gitTag=${PV}" ${EGO_PN}/caddy || die
}

src_install() {
	dobin bin/caddy
	dodoc src/${EGO_PN}/{dist/CHANGES.txt,README.md}

	newinitd "${FILESDIR}"/caddy.initd-r1 caddy
	newconfd "${FILESDIR}"/caddy.confd-r1 caddy
	systemd_dounit "${FILESDIR}"/caddy.service

	keepdir /var/log/caddy
	fowners caddy:caddy /var/log/caddy

	keepdir /etc/caddy/ssl
	fperms 750 /etc/caddy/ssl
	fowners caddy:caddy /etc/caddy/ssl

	insinto /etc/caddy
	doins "${FILESDIR}"/Caddyfile.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/caddy.logrotate caddy
}

pkg_postinst() {
	# caddy currently does not support dropping privileges so we
	# change attributes with setcap to allow access to priv ports
	# https://caddyserver.com/docs/faq
	setcap "cap_net_bind_service=+ep" "${EROOT%/}"/usr/bin/caddy || die
}
