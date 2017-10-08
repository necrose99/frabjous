# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="41102bd"
EGO_PN="github.com/ipfs/${PN}"
DESCRIPTION="IPFS implementation written in Go"
HOMEPAGE="https://ipfs.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse"

RDEPEND="fuse? ( sys-fs/fuse:0 )"
DEPEND="|| ( net-misc/wget net-misc/curl )"

RESTRICT="mirror strip"

DOCS=( {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "net-p2p/go-ipfs require 'network-sandbox' to be disabled in FEATURES"
}

src_prepare() {
	sed -i \
		-e "s:-X:-s -w -X:" \
		-e "s:CurrentCommit=.*:CurrentCommit=${PKG_COMMIT}\":" \
		cmd/ipfs/Rules.mk || die

	default
}

src_compile() {
	GOPATH="${G}" \
	GOTAGS="$(usex !fuse nofuse '')" \
	emake build
}

src_install() {
	dobin cmd/ipfs/ipfs
	einstalldocs
}
