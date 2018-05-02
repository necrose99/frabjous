# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="6ceb4a1"
EGO_PN="github.com/prometheus/${PN/prometheus-}"
DESCRIPTION="Push acceptor for ephemeral and batch jobs to expose their metrics to Prometheus"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( NOTICE {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup pushgateway
	enewuser pushgateway -1 -1 -1 pushgateway
}

src_compile() {
	export GOPATH="${G}"
	local PROMU="vendor/github.com/prometheus/common"
	local GOLDFLAGS="-s -w
		-X ${EGO_PN}/${EGO_PN%/*}/version.Version=${PV}
		-X ${EGO_PN}/${EGO_PN%/*}/version.Revision=${GIT_COMMIT}
		-X ${EGO_PN}/${EGO_PN%/*}/version.Branch=non-git
		-X ${EGO_PN}/${EGO_PN%/*}/version.BuildUser=$(id -un)@$(hostname -f)
		-X ${EGO_PN}/${EGO_PN%/*}/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin pushgateway
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -o pushgateway -g pushgateway -m 0750
	keepdir /var/{lib,log}/pushgateway
}
