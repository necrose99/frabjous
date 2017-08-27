# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/jpillora/${PN}"
EGO_LDFLAGS="-s -w -X main.VERSION=${PV}"
DESCRIPTION="A self-hosted remote torrent client, written in Go"
HOMEPAGE="https://github.com/jpillora/cloud-torrent"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"${EGO_LDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc
	newins "${FILESDIR}"/${PN}.conf ${PN}.json
}

pkg_preinst() {
	enewgroup torrent
	enewuser torrent -1 -1 -1 torrent
}
