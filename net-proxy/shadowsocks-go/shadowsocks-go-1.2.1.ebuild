# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/Yawning/chacha20 6f059cf"
	"golang.org/x/crypto 558b687 github.com/golang/crypto"
)
EGO_PN="github.com/shadowsocks/shadowsocks-go"

inherit golang-vcs-snapshot user

DESCRIPTION="A Go port of Shadowsocks"
HOMEPAGE="https://shadowsocks.org"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup shadowsocks
	enewuser shadowsocks -1 -1 -1 shadowsocks
}

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" \
		${EGO_PN}/cmd/shadowsocks-{httpget,local,server} || die
}

src_install() {
	dobin bin/shadowsocks-{httpget,local,server}
	dodoc src/${EGO_PN}/{CHANGELOG,README.md}

	newinitd "${FILESDIR}"/${PN}-local.initd-r1 ssgo-local
	newinitd "${FILESDIR}"/${PN}-server.initd-r1 ssgo-server

	diropts -o shadowsocks -g shadowsocks -m 0700
	dodir /etc/shadowsocks-go /var/log/shadowsocks-go

	insinto /etc/shadowsocks-go
	newins "${FILESDIR}"/${PN}-local.conf local.json.example
	newins "${FILESDIR}"/${PN}-server.conf server.json.example
}
