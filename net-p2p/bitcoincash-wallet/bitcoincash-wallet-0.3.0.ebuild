# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/cpacia/${PN}"
DESCRIPTION="A Bitcoin Cash P2P SPV Wallet"
HOMEPAGE="https://github.com/cpacia/bitcoincash-wallet"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"-s -w" ${EGO_PN}/cmd/bitcoincash || die
}

src_install() {
	dobin bin/bitcoincash
	dodoc src/${EGO_PN}/README.md
}
