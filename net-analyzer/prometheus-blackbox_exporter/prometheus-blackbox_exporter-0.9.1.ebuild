# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="2272b4e"
EGO_PN="github.com/${PN/-//}"
DESCRIPTION="Allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup blackbox_exporter
	enewuser blackbox_exporter -1 -1 -1 blackbox_exporter
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Version=${PV} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Revision=${GIT_COMMIT} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildUser=$(id -un)@$(hostname -f) \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Branch=non-git \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_test() {
	export GOPATH="${S}"
	local PKGS=( $(go list ./... | grep -v -E '/vendor/') )
	go test -short ${PKGS[@]} || die
}

src_install() {
	dobin bin/blackbox_exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	insinto /etc/blackbox_exporter
	doins blackbox.yml example.yml

	dodoc {NOTICE,{CONFIGURATION,README}.md}
	popd > /dev/null || die

	diropts -o blackbox_exporter -g blackbox_exporter -m 0750
	dodir /var/log/blackbox_exporter
}
