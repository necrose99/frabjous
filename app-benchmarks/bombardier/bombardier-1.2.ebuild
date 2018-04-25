# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/codesenberg/${PN}"
DESCRIPTION="Fast cross-platform HTTP benchmarking tool written in Go"
HOMEPAGE="https://github.com/codesenberg/bombardier"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="simplebenchserver"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w -X main.version=${PV}"

	go build -v -ldflags "${GOLDFLAGS}" || die

	if use simplebenchserver; then
		go build -v -ldflags "-s -w" \
			./cmd/utils/simplebenchserver || die
	fi
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin bombardier
	einstalldocs

	use simplebenchserver && \
		dobin simplebenchserver
}
