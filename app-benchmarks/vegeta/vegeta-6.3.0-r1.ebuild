# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/streadway/quantile b0c5887"
	"golang.org/x/net 8351a75 github.com/golang/net"
	"golang.org/x/text 1cbadb4 github.com/golang/text"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/tsenart/${PN}"
DESCRIPTION="HTTP load testing tool and library. It's over 9000!"
HOMEPAGE="https://github.com/tsenart/vegeta"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

DOCS=( {CHANGELOG,README.md} )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags \
		"-s -w -X main.Version=${PV}" || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin vegeta
	einstalldocs
}
