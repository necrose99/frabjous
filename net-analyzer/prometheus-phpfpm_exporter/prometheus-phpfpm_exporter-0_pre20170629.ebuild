# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e845"
	"github.com/golang/protobuf 2402d76"
	"github.com/matttproud/golang_protobuf_extensions c12348c"
	"github.com/prometheus/client_golang c5b7fcc"
	"github.com/prometheus/client_model fa8ad6f"
	"github.com/prometheus/common dd2f054"
	"github.com/prometheus/procfs fcdb11c"
	"github.com/tomasen/fcgi_client b116e70"
)

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="a77ceea35e33675edca0770814313d9f26449e37"
EGO_PN="github.com/kumina/phpfpm_exporter"
DESCRIPTION="A Prometheus exporter for PHP-FPM"
HOMEPAGE="https://github.com/kumina/phpfpm_exporter"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup phpfpm_exporter
	enewuser phpfpm_exporter -1 -1 -1 phpfpm_exporter
}

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN} || die
}

src_install() {
	dobin bin/phpfpm_exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	popd > /dev/null || die

	diropts -o phpfpm_exporter -g phpfpm_exporter -m 0750
	dodir /var/log/phpfpm_exporter
}
