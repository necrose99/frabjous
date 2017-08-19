# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Godeps
EGO_VENDOR=(
	"collectd.org e84e8af github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml 9906417"
	"github.com/bmizerany/pat c068ca2"
	"github.com/boltdb/bolt 4b1ebc1"
	"github.com/cespare/xxhash 4a94f89"
	"github.com/dgrijalva/jwt-go 24c63f5"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 7d46cd2"
	"github.com/gogo/protobuf 304335"
	"github.com/golang/snappy d9eb7a3"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/jwilder/encoding 2789473"
	"github.com/peterh/liner 8860952"
	"github.com/retailnext/hllpp 38a7bb7"
	"github.com/spaolacci/murmur3 0d12bf8"
	"github.com/uber-go/atomic 74ca5ec"
	"github.com/uber-go/zap fbae028"
	"golang.org/x/crypto 9477e0b github.com/golang/crypto"
)
# Deps that are not needed:
# github.com/davecgh/go-spew
# github.com/paulbellamy/ratecounter

PKG_COMMIT="76124df"
EGO_PN="github.com/influxdata/influxdb"
EGO_LDFLAGS="-s -w -X main.version=${PV} -X main.branch=${PV} -X main.commit=${PKG_COMMIT}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-text/asciidoc
	app-text/xmlto"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}

src_prepare() {
	# By default InfluxDB sends anonymous statistics to
	# usage.influxdata.com, let's disable this by default.
	sed -i "s:# reporting.*:reporting-disabled = true:" \
		src/${EGO_PN}/etc/config.sample.toml || die

	eapply_user
}

src_compile() {
	cd src/${EGO_PN} || die

	local PKGS=( ./cmd/influx ./cmd/influxd ./cmd/influx_stress
		./cmd/influx_inspect ./cmd/influx_tsm )

	GOPATH="${S}" go install -v \
		-ldflags "${EGO_LDFLAGS}" "${PKGS[@]}" || die

	emake -C man
}

src_install() {
	local SRC="src/${EGO_PN}"

	dobin bin/${PN/db}*

	insinto /etc/${PN}
	newins ${SRC}/etc/config.sample.toml ${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit ${SRC}/scripts/${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	doman ${SRC}/man/*.1

	diropts -o ${PN} -g ${PN} -m 0750
	keepdir /var/log/${PN}
}
