# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/kevinburke/go-bindata 95df019" )

inherit golang-vcs-snapshot systemd user

COMMIT_HASH="eec3912"
EGO_PN="github.com/influxdata/${PN}"
DESCRIPTION="Open source monitoring and visualization UI for the TICK stack"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror strip"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-apps/yarn"

DOCS=( CHANGELOG.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "www-apps/chronograf requires 'network-sandbox' to be disabled in FEATURES"

	enewgroup chronograf
	enewuser chronograf -1 -1 /var/lib/chronograf chronograf
}

src_prepare() {
	sed -i \
		-e "s:VERSION ?=.*:VERSION ?= ${PV}:g" \
		-e "s:COMMIT ?=.*:COMMIT ?= ${COMMIT_HASH}:g" \
		Makefile || die

	emake .jsdep
	default
}

src_compile() {
	export GOPATH="${G}"
	local PATH="${G}/bin:$PATH"

	ebegin "Building go-bindata locally"
	pushd vendor/github.com/kevinburke/go-bindata > /dev/null || die
	go build -v -ldflags "-s -w" -o \
		"${G}"/bin/go-bindata ./go-bindata || die
	popd > /dev/null || die
	eend $?

	touch .godep || die
	make build || die
}

src_test() {
	emake test
}

src_install() {
	dobin chronograf
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_dounit etc/scripts/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	insinto /usr/share/chronograf/canned
	doins canned/*.json

	insinto /etc/logrotate.d
	newins etc/scripts/logrotate chronograf

	diropts -o chronograf -g chronograf -m 0750
	keepdir /var/{lib,log}/chronograf
}
