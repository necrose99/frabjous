# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text 836efe4 github.com/golang/text" )
EGO_PN="github.com/rakyll/hey"

inherit golang-vcs-snapshot

DESCRIPTION="HTTP load generator, ApacheBench (ab) replacement"
HOMEPAGE="https://github.com/rakyll/hey"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v ${EGO_PN} || die
}

src_install() {
	dobin bin/hey
	dodoc src/${EGO_PN}/README.md
}
