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
)

inherit golang-vcs-snapshot systemd user

GIT_COMMIT="a8b4bed735a03f234fcfffba85302f51025e6b1d"
EGO_PN="github.com/kumina/postfix_exporter"
DESCRIPTION="A Prometheus metrics exporter for the Postfix mail server"
HOMEPAGE="https://github.com/kumina/postfix_exporter"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup postfix_exporter
	enewuser postfix_exporter -1 -1 -1 postfix_exporter
}

src_compile() {
	GOPATH="${G}" go install -v \
		-ldflags "-s -w" || die
}

src_install() {
	dobin "${G}"/bin/postfix_exporter
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	diropts -o postfix_exporter -g postfix_exporter -m 0750
	dodir /var/log/postfix_exporter
}
