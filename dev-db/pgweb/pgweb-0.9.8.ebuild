# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

PKG_COMMIT="5e748d0"
EGO_PN="github.com/sosedoff/pgweb"
DESCRIPTION="Web-based PostgreSQL database browser written in Go"
HOMEPAGE="https://sosedoff.github.io/pgweb/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w \
		-X main.version=${PV} \
		-X ${EGO_PN}/pkg/command.BuildTime=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
		-X ${EGO_PN}/pkg/command.GitCommit=${PKG_COMMIT}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/pgweb

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodoc src/${EGO_PN}/{CHANGELOG,README}.md

	diropts -o pgweb -g pgweb -m 0750
	dodir /var/log/pgweb
}
