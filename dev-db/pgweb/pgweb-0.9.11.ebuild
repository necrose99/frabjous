# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="c32784e"
EGO_PN="github.com/sosedoff/pgweb"
DESCRIPTION="Web-based PostgreSQL database browser written in Go"
HOMEPAGE="https://sosedoff.github.io/pgweb/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+daemon test"

DOCS=( {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	if use test; then
		has network-sandbox $FEATURES && \
			die "The test phase requires 'network-sandbox' to be disabled in FEATURES"
		ewarn
		ewarn "The tests requires a local PostgreSQL server running on the default port"
		ewarn
	fi

	if use daemon; then
		enewgroup pgweb
		enewuser pgweb -1 -1 -1 pgweb
	fi
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/pkg/command.BuildTime=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
		-X ${EGO_PN}/pkg/command.GitCommit=${PKG_COMMIT}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_test() {
	go test -v ./pkg/... || die
}

src_install() {
	dobin pgweb
	einstalldocs

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		diropts -o pgweb -g pgweb -m 0750
		dodir /var/log/pgweb
	fi
}
