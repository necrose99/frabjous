# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
# Deps that are not needed:
# golang.org/x/sys
EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e845"
	"github.com/cloudfoundry-community/go-cfenv f920e95"
	"github.com/garyburd/redigo 47dc60e"
	"github.com/golang/protobuf 1e59b77"
	"github.com/matttproud/golang_protobuf_extensions 3247c84"
	"github.com/mitchellh/mapstructure 06020f8"
	"github.com/prometheus/client_golang c5b7fcc"
	"github.com/prometheus/client_model 6f38060"
	"github.com/prometheus/common e3fb1a1"
	"github.com/prometheus/procfs a6e9df8"
	"github.com/prometheus/prometheus 0a74f98"
	"github.com/Sirupsen/logrus f006c2a"
	"golang.org/x/crypto 9f005a0 github.com/golang/crypto"
)

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="78e6e67db275f53ce63c3260518ecad2b3b89085"
EGO_PN="github.com/oliver006/redis_exporter"
DESCRIPTION="A server that export Redis metrics for Prometheus consumption"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	if use test; then
		has network-sandbox $FEATURES && \
			die "The test phase requires 'network-sandbox' to be disabled in FEATURES"
		ewarn
		ewarn "The test phase requires a local Redis server running on the default port"
		ewarn
	fi

	enewgroup redis_exporter
	enewuser redis_exporter -1 -1 -1 redis_exporter
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.VERSION=${PV} \
		-X main.BUILD_DATE=$(date -u '+%Y-%m-%d') \
		-X main.COMMIT_SHA1=${GIT_COMMIT}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dobin redis_exporter
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /usr/share/${PN}
	doins -r contrib/*

	diropts -o redis_exporter -g redis_exporter -m 0750
	dodir /var/log/redis_exporter
}
