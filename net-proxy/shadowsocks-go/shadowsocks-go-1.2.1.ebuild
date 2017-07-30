# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/Yawning/chacha20 6f059cf"
	"golang.org/x/crypto 558b687 github.com/golang/crypto"
)
EGO_PN="github.com/shadowsocks/shadowsocks-go"

inherit golang-vcs-snapshot user

DESCRIPTION="A lightweight tunnel proxy which can help you get through firewalls"
HOMEPAGE="https://shadowsocks.org"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

SS="shadowsocks"

pkg_setup() {
	enewgroup ${SS}
	enewuser ${SS} -1 -1 -1 ${SS}
}

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" \
		${EGO_PN}/cmd/${SS}-{httpget,local,server} || die
}

src_install() {
	dobin bin/${SS}-{httpget,local,server}
	dodoc src/${EGO_PN}/{CHANGELOG,README.md}

	newinitd "${FILESDIR}"/${PN}-local.initd ${SS}-local
	newinitd "${FILESDIR}"/${PN}-server.initd ${SS}-server

	insinto /etc/${SS}
	newins "${FILESDIR}"/${PN}-local.conf local.json
	newins "${FILESDIR}"/${PN}-server.conf server.json

	keepdir /var/log/${SS}
	fperms 750 /{etc,var/log}/${SS}
	fowners ${SS}:${SS} /{etc,var/log}/${SS}
}
