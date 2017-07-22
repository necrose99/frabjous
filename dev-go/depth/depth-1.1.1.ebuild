# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

EGO_PN="github.com/KyleBanks/${PN}"

inherit golang-vcs-snapshot

DESCRIPTION="Retrieve and visualize Go source code dependency trees"
HOMEPAGE="https://github.com/KyleBanks/depth"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md
}
