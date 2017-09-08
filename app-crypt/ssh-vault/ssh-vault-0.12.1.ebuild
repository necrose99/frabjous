# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/kr/pty 2c10821"
	"github.com/ssh-vault/crypto ae180e0"
	"github.com/ssh-vault/ssh2pem c1edc64"
	"github.com/ssh-vault/go-keychain 69c518e"
	"golang.org/x/crypto 81e9090 github.com/golang/crypto"
	"golang.org/x/sys 9aade4d github.com/golang/sys"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/${PN}/${PN}"
DESCRIPTION="Encrypt/Decrypt using SSH private keys"
HOMEPAGE="https://ssh-vault.com"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w -X main.version=${PV}"

	GOPATH="${S}" go build -v -ldflags "${GOLDFLAGS}" \
		${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin ssh-vault
}

pkg_postinst() {
	einfo "See https://ssh-vault.com for configuration guide."
}
