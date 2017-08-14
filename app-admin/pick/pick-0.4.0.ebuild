# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with dependencies.tsv
EGO_VENDOR=(
	"github.com/BurntSushi/toml 9906417"
	"github.com/atotto/clipboard bb272b8"
	"github.com/leonklingele/randomstring fd6b15e"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/pkg/term b1f72af"
	"github.com/spf13/cobra 92ea23a"
	"github.com/spf13/pflag 9ff6c69"
	"golang.org/x/crypto 453249f github.com/golang/crypto"
)
EGO_PN="github.com/bndw/${PN}"
EGO_LDFLAGS="-s -w -X main.version=${PV}"

inherit golang-vcs-snapshot

DESCRIPTION="A minimal password manager"
HOMEPAGE="https://bndw.github.io/pick/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"${EGO_LDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
}
