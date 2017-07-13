# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/ssh-vault/crypto ae180e0"
	"github.com/ssh-vault/ssh2pem 02e6a01"
	"golang.org/x/crypto dd85ac7 github.com/golang/crypto"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/${PN}/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Encrypt/Decrypt using SSH private keys"
HOMEPAGE="https://ssh-vault.com"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "-X main.version=${PV}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
}

pkg_postinst() {
	einfo "See https://ssh-vault.com for configuration guide."
}
