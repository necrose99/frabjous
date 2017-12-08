# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
# Deps that are not needed:
# golang.org/x/crypto
EGO_VENDOR=(
	"github.com/google/btree 0c3044b"
	"github.com/jessevdk/go-flags 8bc97d6"
	"github.com/lestrrat/go-pdebug 2e6eaaa"
	"github.com/mattn/go-runewidth 737072b"
	"github.com/nsf/termbox-go abe82ce"
	"github.com/pkg/errors 248dadf"
	"github.com/stretchr/testify 18a02ba"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/peco/peco"
DESCRIPTION="Simplistic interactive filtering tool"
HOMEPAGE="https://github.com/peco/peco"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

DOCS=( Changes README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" \
		./cmd/peco || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin peco
	einstalldocs
}
