# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="e48bd68"
EGO_PN="github.com/hnlq715/nginx-vts-exporter"
DESCRIPTION="A server that scrapes Nginx vts stats and exports them for Prometheus"
HOMEPAGE="https://github.com/hnlq715/nginx-vts-exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup nginx_vts_exporter
	enewuser nginx_vts_exporter -1 -1 -1 nginx_vts_exporter
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/vendor/github.com/prometheus/common/version.Version=${PV} \
		-X ${EGO_PN}/vendor/github.com/prometheus/common/version.Revision=${GIT_COMMIT} \
		-X ${EGO_PN}/vendor/github.com/prometheus/common/version.BuildUser=$(id -un)@$(hostname -f) \
		-X ${EGO_PN}/vendor/github.com/prometheus/common/version.Branch=non-git \
		-X ${EGO_PN}/vendor/github.com/prometheus/common/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/nginx-vts-exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	popd > /dev/null || die

	diropts -o nginx_vts_exporter -g nginx_vts_exporter -m 0750
	dodir /var/log/nginx_vts_exporter
}
