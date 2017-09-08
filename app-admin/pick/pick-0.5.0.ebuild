# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/bndw/pick"
DESCRIPTION="A minimal password manager written in Go"
HOMEPAGE="https://bndw.github.io/pick/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w -X main.version=${PV}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/pick
}
