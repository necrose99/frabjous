# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/wrouesnel/postgres_exporter"
DESCRIPTION="Prometheus exporter for PostgreSQL server metrics"
HOMEPAGE="https://github.com/wrouesnel/postgres_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup postgres_exporter
	enewuser postgres_exporter -1 -1 -1 postgres_exporter
}

src_compile() {
	local GOLDFLAGS="-s -w -X main.Version=${PV}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_test() {
	export GOPATH="${S}"
	emake -C src/${EGO_PN} test
}

src_install() {
	dobin bin/postgres_exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	popd > /dev/null || die

	diropts -o postgres_exporter -g postgres_exporter -m 0750
	dodir /var/log/postgres_exporter
}
