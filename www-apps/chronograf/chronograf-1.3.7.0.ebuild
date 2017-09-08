# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

PKG_COMMIT="a9358a3"
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

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
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
	touch src/${EGO_PN}/.godep || die

	GOPATH="${S}" make -C src/${EGO_PN} build || die
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin ${PN}

	systemd_dounit etc/scripts/${PN}.service

	insinto /usr/share/${PN}/canned
	doins canned/*.json

	insinto /etc/logrotate.d
	newins etc/scripts/logrotate ${PN}
	popd > /dev/null || die

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	diropts -o ${PN} -g ${PN} -m 0750
	dodir /var/lib/${PN}
	diropts -o ${PN} -g ${PN} -m 0700
	dodir /var/log/${PN}
}
