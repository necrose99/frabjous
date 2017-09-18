# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e845"
	"github.com/garyburd/redigo 8873b2f"
	"github.com/golang/protobuf 2402d76"
	"github.com/matttproud/golang_protobuf_extensions c12348c"
	"github.com/prometheus/client_golang c5b7fcc"
	"github.com/prometheus/client_model fa8ad6f"
	"github.com/prometheus/common dd2f054"
	"github.com/prometheus/procfs fcdb11c"
	"github.com/Sirupsen/logrus d264929"
)

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="01ace8c5ffded06c5484fd52334e333a5235e4c4"
EGO_PN="github.com/oliver006/redis_exporter"
DESCRIPTION="A server that export Redis metrics for Prometheus consumption"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( dev-db/redis )"

RESTRICT="mirror strip"

pkg_setup() {
	if use test; then
		has network-sandbox $FEATURES && \
			die "The test phase require 'network-sandbox' to be disabled in FEATURES"

		ewarn
		ewarn "The test phase require a local Redis server running on the default port"
		ewarn
	fi

	enewgroup redis_exporter
	enewuser redis_exporter -1 -1 -1 redis_exporter
}

src_prepare() {
	sed -i \
		-e "s:VERSION     =.*:VERSION = \"${PV}\":" \
		-e "s:BUILD_DATE  =.*:BUILD_DATE = \"$(date -u '+%Y-%m-%d' )\":" \
		-e "s:COMMIT_SHA1 =.*:COMMIT_SHA1 = \"${GIT_COMMIT}\":" \
		src/${EGO_PN}/main.go || die

	default
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
	dobin bin/redis_exporter

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	pushd src/${EGO_PN} > /dev/null || die
	insinto /usr/share/${PN}
	doins -r contrib/*.json

	dodoc README.md
	popd > /dev/null || die

	diropts -o redis_exporter -g redis_exporter -m 0750
	dodir /var/log/redis_exporter
}
