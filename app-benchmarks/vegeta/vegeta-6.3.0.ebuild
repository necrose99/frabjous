# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/streadway/quantile b0c5887"
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text cfdf022 github.com/golang/text"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/tsenart/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="HTTP load testing tool and library. It's over 9000!"
HOMEPAGE="https://github.com/tsenart/vegeta"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "-X main.Version=v${PV}" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/{README.md,CHANGELOG}
}
