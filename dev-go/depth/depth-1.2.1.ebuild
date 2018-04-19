# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/KyleBanks/depth"
DESCRIPTION="Retrieve and visualize Go source code dependency trees"
HOMEPAGE="https://github.com/KyleBanks/depth"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	GOPATH="${G}" go build -v \
		-ldflags "-s -w" ./cmd/depth || die
}

src_test() {
	GOPATH="${G}" go test || die
}

src_install() {
	dobin depth
	dodoc README.md
}
