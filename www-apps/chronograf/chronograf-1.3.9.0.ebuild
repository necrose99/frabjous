# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="f13a011"
EGO_PN="github.com/influxdata/${PN}"
DESCRIPTION="Open source monitoring and visualization UI for the TICK stack"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-go/go-bindata
	>=sys-apps/yarn-1.0.0"

RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	has network-sandbox $FEATURES && \
		die "www-apps/chronograf require 'network-sandbox' to be disabled in FEATURES"

	enewgroup chronograf
	enewuser chronograf -1 -1 /var/lib/chronograf chronograf
}

src_prepare() {
	sed -i \
		-e "s:VERSION ?=.*:VERSION ?= ${PV}:g" \
		-e "s:COMMIT ?=.*:COMMIT ?= ${PKG_COMMIT}:g" \
		Makefile || die

	# Unfortunately 'network-sandbox' needs to disabled
	# because sys-apps/yarn fetch dependencies here:
	emake .jsdep

	default
}

src_compile() {
	# We already have go-bindata system-wide,
	# so there is no need to build it locally.
	# Stop! Hammer time!
	touch .godep || die

	GOPATH="${G}" make build || die
}

src_test() {
	emake GOPATH="${G}" test
}

src_install() {
	dobin chronograf

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_dounit etc/scripts/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	insinto /usr/share/chronograf/canned
	doins canned/*.json

	insinto /etc/logrotate.d
	newins etc/scripts/logrotate chronograf

	diropts -o chronograf -g chronograf -m 0750
	dodir /var/{lib,log}/chronograf
}
