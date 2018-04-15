# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/maximbaz/${PN}"
DESCRIPTION="A tool that can detect when your YubiKey is waiting for a touch"
HOMEPAGE="https://github.com/maximbaz/yubikey-touch-detector"
SRC_URI="https://${EGO_PN}/releases/download/${PV}/${PN}-src.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-auth/pam_u2f[touch-notifications]"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" \
		-o yubikey-touch-detector || die
}

src_install() {
	dobin yubikey-touch-detector
	einstalldocs
}
