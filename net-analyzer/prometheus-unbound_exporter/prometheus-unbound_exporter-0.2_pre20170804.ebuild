# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e845"
	"github.com/golang/protobuf 2402d76"
	"github.com/matttproud/golang_protobuf_extensions c12348c"
	"github.com/prometheus/client_golang c5b7fcc"
	"github.com/prometheus/client_model fa8ad6f"
	"github.com/prometheus/common dd2f054"
	"github.com/prometheus/procfs fcdb11c"
	"github.com/Sirupsen/logrus d264929"
)

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="f538243789ba092158a6a403be05dc537e80f0d8"
EGO_PN="github.com/kumina/unbound_exporter"
DESCRIPTION="A Prometheus exporter for Unbound"
HOMEPAGE="https://github.com/kumina/unbound_exporter"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup unbound_exporter
	enewuser unbound_exporter -1 -1 -1 unbound_exporter
}

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN} || die
}

src_test() {
	export GOPATH="${S}"
	local PKGS=( $(go list ./... | grep -v -E '/vendor/') )
	go test -short ${PKGS[@]} || die
}

src_install() {
	dobin bin/unbound_exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	popd > /dev/null || die

	diropts -o unbound_exporter -g unbound_exporter -m 0750
	dodir /var/log/unbound_exporter
}
