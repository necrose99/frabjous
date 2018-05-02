# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/ncabatoff/process-exporter"
DESCRIPTION="A Prometheus exporter that mines /proc to report on selected processes"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup process-exporter
	enewuser process-exporter -1 -1 -1 process-exporter
}

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" \
		./cmd/process-exporter || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin process-exporter
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -o process-exporter -g process-exporter -m 0750
	keepdir /var/log/process_exporter
}
