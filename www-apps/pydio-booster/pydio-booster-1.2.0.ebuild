# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/mholt/caddy 0b4dda0" #v0.10.7
	"github.com/nsqio/go-nsq eee57a3" #v1.0.7
	"github.com/nsqio/nsq a73c39f"
	"github.com/nsqio/go-diskqueue d7805f8"
	"github.com/blang/semver 2ee8785" #v3.5.1
	"github.com/bmizerany/perks d9a9656"
	"github.com/julienschmidt/httprouter 975b5c4"
	"github.com/jasonlvhit/gocron 42a5804"
	"github.com/dgrijalva/jwt-go 268038b" #v2.7.0
	"github.com/aws/aws-sdk-go e63027a" #v1.10.33
	"github.com/gorilla/websocket ea4d1f6" #v1.2.0
	"github.com/nu7hatch/gouuid 179d4d0"
	"github.com/golang/snappy 553a641"
	"golang.org/x/net 57efc9c github.com/golang/net"
	"gopkg.in/square/go-jose.v1 aa2e30f github.com/square/go-jose" #1.0.1
	"gopkg.in/natefinch/lumberjack.v2 a96e638 github.com/natefinch/lumberjack" #v2.1
)
EGO_PN="github.com/pydio/${PN}"
PGK_COMMIT="b99a58d8d2802710a0bdb67bb6c6955662565744"

inherit golang-vcs-snapshot

DESCRIPTION="Empower your Pydio server with this golang-based dedicated tool"
HOMEPAGE="https://pydio.com"
SRC_URI="https://${EGO_PN}/archive/${PGK_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" ${EGO_PN}/cmd/pydio || die
}

src_install() {
	dobin bin/pydio

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc/${PN}
	doins "${FILESDIR}"/pydio.conf
}
