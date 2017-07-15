# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/streadway/quantile b0c5887"
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text 836efe4 github.com/golang/text" )
EGO_PN="github.com/tsenart/${PN}"
EGO_LDFLAGS="-X main.Version=v${PV}"

inherit golang-vcs-snapshot

DESCRIPTION="HTTP load testing tool and library. It's over 9000!"
HOMEPAGE="https://github.com/tsenart/vegeta"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "${EGO_LDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/{README.md,CHANGELOG}
}
