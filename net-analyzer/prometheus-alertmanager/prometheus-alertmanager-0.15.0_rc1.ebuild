# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="acb111e"
EGO_PN="github.com/prometheus/${PN/prometheus-}"
DESCRIPTION="Handles alerts sent by client applications such as the Prometheus"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://${EGO_PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror strip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( NOTICE {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup alertmanager
	enewuser alertmanager -1 -1 /var/lib/alertmanager alertmanager
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Version=${PV/_rc/-rc.}
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Revision=${GIT_COMMIT}
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildUser=$(id -un)@$(hostname -f)
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Branch=non-git
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	go install -v -ldflags "${GOLDFLAGS}" \
		./cmd/{alertmanager,amtool} || die
}

src_test() {
	go test -v $(go list ./... | grep -v /test) || die
}

src_install() {
	dobin "${G}"/bin/{alertmanager,amtool}
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	insinto /etc/alertmanager
	newins doc/examples/simple.yml alertmanager.yml.example

	diropts -o alertmanager -g alertmanager -m 0750
	keepdir /var/{lib,log}/alertmanager
}

pkg_postinst() {
	if [ ! -e "${EROOT%/}"/etc/alertmanager/alertmanager.yml ]; then
		elog "No alertmanager.yml found, copying the example over"
		cp "${EROOT%/}"/etc/alertmanager/alertmanager.yml{.example,} || die
	else
		elog "alertmanager.yml found, please check example file for possible changes"
	fi
}
