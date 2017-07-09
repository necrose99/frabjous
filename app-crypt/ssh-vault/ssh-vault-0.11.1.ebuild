# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/keybase/go-keychain 69c518e5bfff89ad62db81a185634d3aeac3c453"
	"github.com/kr/pty 2c10821df3c3cf905230d078702dfbe9404c9b23"
	"github.com/ssh-vault/crypto ae180e0dba4c4b9516c202881bc333472c39c0d1"
	"github.com/ssh-vault/ssh2pem 02e6a0142e2ba52a22dc41a20a3227c5c76e99f2"
	"golang.org/x/crypto a48ac81e47fd6f9ed1258f3b60ae9e75f93cb7ed github.com/golang/crypto"
)

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/${PN}/${PN}/..."
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Encrypt/Decrypt using SSH private keys"
HOMEPAGE="https://ssh-vault.com"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/go-1.8"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"
	cd src/${EGO_PN%/*} || die

	go install -ldflags "-X main.version=${PV}" ./cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
}

pkg_postinst() {
	einfo "See https://ssh-vault.com for configuration guide."
}
