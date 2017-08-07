# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="9e87035"
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
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	if has network-sandbox $FEATURES; then
		eerror "sys-apps/yarn require 'network-sandbox' to be disabled in FEATURES." && die
	fi

	sed -i \
		-e "s:VERSION ?=.*:VERSION ?= ${PV}:g" \
		-e "s:COMMIT ?=.*:COMMIT ?= ${GIT_COMMIT}:g" \
		src/${EGO_PN}/Makefile || die

	emake -C src/${EGO_PN} .jsdep

	default
}

src_compile() {
	touch src/${EGO_PN}/.godep || die

	GOPATH="${S}" make -C src/${EGO_PN} build || die
}

src_install() {
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	pushd src/${EGO_PN} > /dev/null || die
	dobin ${PN}

	systemd_dounit etc/scripts/${PN}.service

	insinto /usr/share/${PN}/canned
	doins canned/*.json

	insinto /etc/logrotate.d
	newins etc/scripts/logrotate ${PN}
	popd > /dev/null || die

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
}
