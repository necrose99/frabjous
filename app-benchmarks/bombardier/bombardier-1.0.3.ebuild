# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/codesenberg/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast cross-platform HTTP benchmarking tool written in Go"
HOMEPAGE="https://github.com/codesenberg/bombardier"
SRC_URI="${ARCHIVE_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "-X main.version=${PV}" ${EGO_PN} || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/README.md
}
