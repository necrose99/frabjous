# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/jpillora/${PN}"
DESCRIPTION="Cloud Torrent: a self-hosted remote torrent client"
HOMEPAGE="https://github.com/jpillora/cloud-torrent"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon"

RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w -X main.VERSION=${PV}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_install() {
	dobin cloud-torrent

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		insinto /etc/cloud-torrent
		newins "${FILESDIR}"/${PN}.conf \
			cloud-torrent.json.example
	fi
}

pkg_preinst() {
	if use daemon; then
		enewgroup torrent
		enewuser torrent -1 -1 -1 torrent
	fi
}

pkg_postinst() {
	if use daemon; then
		if [ ! -e "${EROOT%/}"/etc/${PN}/cloud-torrent.json ]; then
			elog "No cloud-torrent.json found, copying the example over"
			cp "${EROOT%/}"/etc/${PN}/cloud-torrent.json{.example,} || die
		fi
	fi
}
