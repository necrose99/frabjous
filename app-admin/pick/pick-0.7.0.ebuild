# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/bndw/pick"
DESCRIPTION="A minimal password manager written in Go"
HOMEPAGE="https://bndw.github.io/pick/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"

	go build -v -ldflags "-s -w
		-X main.version=${PV}" || die
}

src_install() {
	dobin pick
}
