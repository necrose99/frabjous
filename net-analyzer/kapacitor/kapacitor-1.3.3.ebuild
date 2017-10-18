# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot systemd user

COMMIT_HASH="ce586f3"
EGO_PN="github.com/influxdata/kapacitor"
DESCRIPTION="A framework for processing, monitoring, and alerting on time series data"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup kapacitor
	enewuser kapacitor -1 -1 /var/lib/kapacitor kapacitor
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.version=${PV} \
		-X main.branch=${PV} \
		-X main.commit=${COMMIT_HASH}"

	go install -v -ldflags \
		"${GOLDFLAGS}" ./cmd/kapacitor{,d} || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin "${G}"/bin/kapacitor{,d}

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit scripts/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	insinto /etc/kapacitor
	newins etc/kapacitor/kapacitor.conf kapacitor.conf.example

	insinto /etc/logrotate.d
	doins etc/logrotate.d/kapacitor

	if use examples; then
		docinto examples
		dodoc -r examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi

	dobashcomp usr/share/bash-completion/completions/kapacitor

	diropts -o kapacitor -g kapacitor -m 0750
	dodir /var/{lib,log}/kapacitor
}

pkg_postinst() {
	if [ ! -e "${EROOT%/}"/etc/${PN}/kapacitor.conf ]; then
		elog "No kapacitor.conf found, copying the example over"
		cp "${EROOT%/}"/etc/${PN}/kapacitor.conf{.example,} || die
	else
		elog "kapacitor.conf found, please check example file for possible changes"
	fi
}
