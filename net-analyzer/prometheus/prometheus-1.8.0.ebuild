# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="3569eef"
EGO_PN="github.com/${PN}/${PN}"
DESCRIPTION="The Prometheus monitoring system and time series database"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RESTRICT="mirror strip"

DOCS=( {CHANGELOG,CONTRIBUTING,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup prometheus
	enewuser prometheus -1 -1 /var/lib/prometheus prometheus
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Version=${PV} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Revision=${GIT_COMMIT} \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildUser=$(id -un)@$(hostname -f) \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.Branch=non-git \
		-X ${EGO_PN}/vendor/${EGO_PN%/*}/common/version.BuildDate=$(date -u '+%Y%m%d-%I:%M:%S')"

	GOPATH="${G}" go install -v -ldflags "${GOLDFLAGS}" \
		${EGO_PN}/cmd/{prometheus,promtool} || die
}

src_install() {
	dobin "${G}"/bin/{prometheus,promtool}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	insinto /etc/prometheus
	newins documentation/examples/prometheus.yml \
		prometheus.yml.example

	insinto /usr/share/prometheus
	doins -r console_libraries consoles

	dosym ../../usr/share/prometheus/console_libraries \
		/etc/prometheus/console_libraries
	dosym ../../usr/share/prometheus/consoles \
		/etc/prometheus/consoles

	einstalldocs

	if use examples; then
		docinto examples
		dodoc -r examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi

	diropts -o prometheus -g prometheus -m 0750
	dodir /var/{lib,log}/prometheus
}

pkg_postinst() {
	if [ ! -e "${EROOT%/}"/etc/${PN}/prometheus.yml ]; then
		elog "No prometheus.yml found, copying the example over"
		cp "${EROOT%/}"/etc/${PN}/prometheus.yml{.example,} || die
	else
		elog "prometheus.yml found, please check example file for possible changes"
	fi
}
