# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build user

EGO_PN="github.com/mholt/${PN}/..."
EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com/"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.8"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" go install -ldflags "-X github.com/mholt/caddy/caddy/caddymain.gitTag=${PV}" ${EGO_PN%/*}/caddy || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN%/*}/README.md src/${EGO_PN%/*}/dist/CHANGES.txt

	newinitd "${FILESDIR}"/caddy.initd ${PN}
	newconfd "${FILESDIR}"/caddy.confd ${PN}

	keepdir /var/log/caddy
	fowners ${PN}:${PN} /var/log/caddy

	keepdir /etc/caddy/ssl
	fperms 750 /etc/caddy/ssl
	fowners ${PN}:${PN} /etc/caddy/ssl

	insinto /etc/caddy
	doins "${FILESDIR}"/Caddyfile.example
}
