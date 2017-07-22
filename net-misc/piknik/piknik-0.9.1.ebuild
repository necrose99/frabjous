# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

EGO_VENDOR=(
	"github.com/BurntSushi/toml b26d9c3" #v0.3.0
	"github.com/minio/blake2b-simd 3f5f724"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/yawning/chacha20 70289bb"
	"golang.org/x/crypto 6914964 github.com/golang/crypto"
)
EGO_PN="github.com/jedisct1/${PN}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Copy/paste anything over the network"
HOMEPAGE="https://github.com/jedisct1/piknik"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc
	newins "${FILESDIR}"/${PN}.conf ${PN}.toml
}

pkg_preinst() {
    enewgroup ${PN}
    enewuser ${PN} -1 -1 -1 ${PN}
}
