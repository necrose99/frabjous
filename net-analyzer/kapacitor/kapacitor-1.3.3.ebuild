# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot systemd user

PKG_COMMIT="ce586f3"
EGO_PN="github.com/influxdata/kapacitor"
EGO_LDFLAGS="-s -w -X main.version=${PV}
	-X main.branch=${PV} -X main.commit=${PKG_COMMIT}"

DESCRIPTION="A framework for processing, monitoring, and alerting on time series data"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup kapacitor
	enewuser kapacitor -1 -1 /var/lib/kapacitor kapacitor
}

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "${EGO_LDFLAGS}" ${EGO_PN}/cmd/kapacitor{,d} || die
}

src_install() {
	dobin bin/kapacitor{,d}

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	pushd src/${EGO_PN} > /dev/null || die
	systemd_dounit scripts/kapacitor.service

	insinto /etc/kapacitor
	doins etc/kapacitor/kapacitor.conf

	insinto /etc/logrotate.d
	doins etc/logrotate.d/kapacitor

	if use examples; then
		docinto examples
		dodoc -r examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi

	dobashcomp usr/share/bash-completion/completions/kapacitor
	popd > /dev/null || die

	diropts -o kapacitor -g kapacitor -m 0750
	dodir /var/{lib,log}/kapacitor
}
