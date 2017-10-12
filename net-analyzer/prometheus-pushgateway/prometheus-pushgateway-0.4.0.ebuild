# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="6ceb4a1"
EGO_PN="github.com/${PN/-//}"
DESCRIPTION="Push acceptor for ephemeral and batch jobs to expose their metrics to Prometheus"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

DOCS=( {NOTICE,{CHANGELOG,README}.md} )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup pushgateway
	enewuser pushgateway -1 -1 -1 pushgateway
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Version=${PV} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Revision=${GIT_COMMIT} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildUser=$(id -un)@$(hostname -f) \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Branch=non-git \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	GOPATH="${G}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin "${G}"/bin/pushgateway
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -o pushgateway -g pushgateway -m 0750
	dodir /var/{lib,log}/pushgateway
}
