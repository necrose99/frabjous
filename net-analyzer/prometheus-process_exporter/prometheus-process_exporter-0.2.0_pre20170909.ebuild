# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGIT_COMMIT="b42394e76d8973328e54de8dcdc1c3d8aa968ed5"
EGO_PN="github.com/ncabatoff/process-exporter"
DESCRIPTION="A Prometheus exporter that mines /proc to report on selected processes"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup process_exporter
	enewuser process_exporter -1 -1 -1 process_exporter
}

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"-s -w" ${EGO_PN}/cmd/process-exporter || die
}

src_test() {
	export GOPATH="${S}"
	local PKGS=( $(go list ./... | grep -v -E '/vendor/') )
	go test -short ${PKGS[@]} || die
}

src_install() {
	dobin bin/process-exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	popd > /dev/null || die

	diropts -o process_exporter -g process_exporter -m 0750
	dodir /var/log/process_exporter
}
