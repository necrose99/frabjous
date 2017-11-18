# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/Yawning/chacha20 e3b1f96"
	"golang.org/x/crypto 9f005a0 github.com/golang/crypto"
)

inherit golang-vcs-snapshot user

EGO_PN="github.com/shadowsocks/${PN}"
DESCRIPTION="A Go port of Shadowsocks"
HOMEPAGE="https://shadowsocks.org"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

DOCS=( CHANGELOG README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup shadowsocks
	enewuser shadowsocks -1 -1 -1 shadowsocks
}

src_compile() {
	export GOPATH="${G}"
	go install -v -ldflags "-s -w" \
		./cmd/shadowsocks-{httpget,local,server} || die
}

src_install() {
	dobin "${G}"/bin/shadowsocks-{httpget,local,server}
	einstalldocs

	newinitd "${FILESDIR}"/${PN}-local.initd-r2 ${PN}-local
	newinitd "${FILESDIR}"/${PN}-server.initd-r2 ${PN}-server

	diropts -o shadowsocks -g shadowsocks -m 0700
	dodir /{etc,var/log}/shadowsocks-go

	insinto /etc/shadowsocks-go
	newins "${FILESDIR}"/${PN}-local.conf local.json.example
	newins "${FILESDIR}"/${PN}-server.conf server.json.example
}
