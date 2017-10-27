# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/cristianoliveira/ergo"
DESCRIPTION="The reverse proxy agent for local domain management"
HOMEPAGE="https://github.com/cristianoliveira/ergo"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-w -s -X main.VERSION=${PV}"

	go build -v -ldflags "${GOLDFLAGS}" || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin ergo
	einstalldocs
}
