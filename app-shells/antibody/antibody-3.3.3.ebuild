# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Gopkg.lock
EGO_VENDOR=(
	"github.com/pierrre/gotestcover 924dca7" #for src_test
	"github.com/alecthomas/kingpin 297a08e"
	"github.com/alecthomas/template a0175ee"
	"github.com/alecthomas/units 2efee85"
	"github.com/caarlos0/gohome 677b1a6"
	"github.com/getantibody/folder 479aa91"
	"github.com/stretchr/testify 69483b4"
	"golang.org/x/crypto e1a4589 github.com/golang/crypto"
	"golang.org/x/net 59a0b19 github.com/golang/net"
	"golang.org/x/sync 57af736 github.com/golang/sync"
)
# Deps that are not needed:
# github.com/davecgh/go-spew
# github.com/pmezard/go-difflib

inherit golang-vcs-snapshot

EGO_PN="github.com/getantibody/antibody"
DESCRIPTION="The fastest shell plugin manager"
HOMEPAGE="https://getantibody.github.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="app-shells/zsh[unicode]
	dev-vcs/git"

RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	if use test; then
		has network-sandbox $FEATURES && \
			die "The test phase require 'network-sandbox' to be disabled in FEATURES"
	fi
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w -X main.version=${PV}"

	go build -v -ldflags "${GOLDFLAGS}" \
		-o "${S}"/antibody || die

	if use test; then
		go install -v -ldflags "-s -w" \
			./vendor/github.com/pierrre/gotestcover || die
	fi
}

src_test() {
	local PATH="${G}/bin:$PATH"
	emake test
}

src_install() {
	dobin antibody
	einstalldocs
}
