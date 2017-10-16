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

inherit golang-vcs-snapshot

EGO_PN="github.com/bndw/pick"
DESCRIPTION="A minimal password manager written in Go"
HOMEPAGE="https://bndw.github.io/pick/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w -X main.version=${PV}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_install() {
	dobin pick
}
