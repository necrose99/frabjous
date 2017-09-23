# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="6801670"
EGO_PN="github.com/influxdata/${PN}"
DESCRIPTION="Open source monitoring and visualization UI for the TICK stack"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-go/go-bindata
	sys-apps/yarn"

RESTRICT="mirror strip"

pkg_setup() {
	if has network-sandbox $FEATURES; then
		die "www-apps/chronograf require 'network-sandbox' to be disabled in FEATURES"
	fi

	enewgroup chronograf
	enewuser chronograf -1 -1 /var/lib/chronograf chronograf
}

src_prepare() {
	sed -i \
		-e "s:VERSION ?=.*:VERSION ?= ${PV}:g" \
		-e "s:COMMIT ?=.*:COMMIT ?= ${PKG_COMMIT}:g" \
		src/${EGO_PN}/Makefile || die

	# Unfortunately 'network-sandbox' needs to disabled
	# because sys-apps/yarn fetch dependencies here:
	emake -C src/${EGO_PN} .jsdep

	default
}

src_compile() {
	# We already have go-bindata system-wide,
	# so there is no need to build it locally.
	touch src/${EGO_PN}/.godep || die

	GOPATH="${S}" \
		make -C src/${EGO_PN} build || die
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin chronograf

	systemd_dounit etc/scripts/chronograf.service

	insinto /usr/share/chronograf/canned
	doins canned/*.json

	insinto /etc/logrotate.d
	newins etc/scripts/logrotate chronograf
	popd > /dev/null || die

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	diropts -o chronograf -g chronograf -m 0750
	dodir /var/{lib,log}/chronograf
}
