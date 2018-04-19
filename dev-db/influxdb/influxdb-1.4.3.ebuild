# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Godeps
# Deps that are not needed:
# github.com/spaolacci/murmur3 0d12bf8
EGO_VENDOR=(
	"collectd.org e84e8af github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813"
	"github.com/bmizerany/pat c068ca2"
	"github.com/boltdb/bolt 4b1ebc1"
	"github.com/cespare/xxhash 1b6d2e4"
	"github.com/davecgh/go-spew 346938d"
	"github.com/dgrijalva/jwt-go 24c63f5"
	"github.com/dgryski/go-bits 2ad8d70"
	"github.com/dgryski/go-bitstream 7d46cd2"
	"github.com/gogo/protobuf 1c2b16b"
	"github.com/golang/snappy d9eb7a3"
	"github.com/google/go-cmp 18107e6"
	"github.com/influxdata/influxql 47c654d"
	"github.com/influxdata/usage-client 6d38953"
	"github.com/influxdata/yamux 1f58ded"
	"github.com/influxdata/yarpc 036268c"
	"github.com/jwilder/encoding 2789473"
	"github.com/paulbellamy/ratecounter 5a11f58"
	"github.com/peterh/liner 8860952"
	"github.com/philhofer/fwd 1612a29"
	"github.com/retailnext/hllpp 38a7bb7"
	"github.com/tinylib/msgp ad0ff2e"
	"github.com/uber-go/atomic 74ca5ec"
	"github.com/uber-go/zap fbae028"
	"github.com/xlab/treeprint 06dfc6f"
	"golang.org/x/crypto 9477e0b github.com/golang/crypto"
	"golang.org/x/sys 062cd7e github.com/golang/sys"
	"golang.org/x/text a71fd10 github.com/golang/text"
	"golang.org/x/time 6dc1736 github.com/golang/time"
)

inherit golang-vcs-snapshot systemd user

MY_PV="${PV/_/}"
COMMIT_HASH="60d27e6"
EGO_PN="github.com/influxdata/${PN}"
DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="man"

DEPEND="man? ( app-text/asciidoc
	app-text/xmlto )"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_prepare() {
	# By default InfluxDB sends anonymous statistics to
	# usage.influxdata.com, let's disable this by default.
	sed -i "s:# reporting.*:reporting-disabled = true:" \
		etc/config.sample.toml || die

	default
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.version=${MY_PV} \
		-X main.branch=non-git \
		-X main.commit=${COMMIT_HASH}"

	go install -v -ldflags "${GOLDFLAGS}" \
		./cmd/influx{,d,_stress,_inspect,_tsm} || die

	use man && emake -C man
}

src_install() {
	dobin "${G}"/bin/influx{,d,_stress,_inspect,_tsm}

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	systemd_dounit scripts/${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd-r1 ${PN}.conf

	insinto /etc/influxdb
	newins etc/config.sample.toml influxdb.conf.example

	use man && doman man/*.1

	diropts -o influxdb -g influxdb -m 0750
	dodir /var/log/influxdb
}

pkg_postinst() {
	if [ ! -e "${EROOT%/}"/etc/${PN}/influxdb.conf ]; then
		elog "No influxdb.conf found, copying the example over"
		cp "${EROOT%/}"/etc/${PN}/influxdb.conf{.example,} || die
	else
		elog "influxdb.conf found, please check example file for possible changes"
	fi
}
