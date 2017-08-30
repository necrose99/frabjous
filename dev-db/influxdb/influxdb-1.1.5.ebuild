# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Godeps
EGO_VENDOR=(
	"github.com/BurntSushi/toml 9906417"
	"github.com/bmizerany/pat c068ca2"
	"github.com/boltdb/bolt 5cc10bb"
	"github.com/dgrijalva/jwt-go 63734ea"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 7d46cd2"
	"github.com/gogo/protobuf 0394392"
	"github.com/golang/snappy d9eb7a3"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/jwilder/encoding 4dada27"
	"github.com/kimor79/gollectd 61d0dee"
	"github.com/peterh/liner 8975875"
	"github.com/rakyll/statik 274df12"
	"github.com/retailnext/hllpp 38a7bb7"
	"golang.org/x/crypto c197bcf github.com/golang/crypto"
)
# Deps that are not needed:
# collectd.org
# github.com/davecgh/go-spew
# github.com/paulbellamy/ratecounter

PKG_COMMIT="cd9363b"
EGO_PN="github.com/influxdata/influxdb"
EGO_LDFLAGS="-s -w -X main.version=${PV} \
	-X main.branch=${PV} -X main.commit=${PKG_COMMIT}"

inherit golang-vcs-snapshot systemd user

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="man"

DEPEND="man? ( app-text/asciidoc
	app-text/xmlto )"

RESTRICT="mirror strip"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_prepare() {
	# By default InfluxDB sends anonymous statistics to
	# usage.influxdata.com, let's disable this by default.
	sed -i "s:# reporting.*:reporting-disabled = true:" \
		src/${EGO_PN}/etc/config.sample.toml || die

	eapply_user
}

src_compile() {
	local PKGS=( ./cmd/influx ./cmd/influxd ./cmd/influx_stress
		./cmd/influx_inspect ./cmd/influx_tsm )

	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${S}" go install -v \
		-ldflags "${EGO_LDFLAGS}" "${PKGS[@]}" || die

	if use man; then
		emake -C man
	fi
	popd > /dev/null || die
}

src_install() {
	dobin bin/${PN/db}*

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd ${PN}.conf

	pushd src/${EGO_PN} > /dev/null || die
	systemd_dounit scripts/${PN}.service

	insinto /etc/influxdb
	newins etc/config.sample.toml ${PN}.conf

	if use man; then
		doman man/*.1
	fi
	popd > /dev/null || die

	diropts -o influxdb -g influxdb -m 0750
	dodir /var/log/influxdb
}
