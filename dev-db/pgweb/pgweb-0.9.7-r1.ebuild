# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

PKG_COMMIT="4833a76"
EGO_PN="github.com/sosedoff/pgweb"
DESCRIPTION="Web-based PostgreSQL database browser written in Go"
HOMEPAGE="https://sosedoff.github.io/pgweb/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+daemon"

RESTRICT="mirror strip"

pkg_setup() {
	if use daemon; then
		enewgroup pgweb
		enewuser pgweb -1 -1 -1 pgweb
	fi
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/pkg/command.BuildTime=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
		-X ${EGO_PN}/pkg/command.GitCommit=${PKG_COMMIT}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/pgweb

	dodoc src/${EGO_PN}/{CHANGELOG,README}.md

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		diropts -o pgweb -g pgweb -m 0750
		dodir /var/log/pgweb
	fi
}
