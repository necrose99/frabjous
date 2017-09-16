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

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"-s -w -X main.Version=v${PV}" ${EGO_PN} || die
}

src_install() {
	dobin bin/vegeta
	dodoc src/${EGO_PN}/{README.md,CHANGELOG}
}
