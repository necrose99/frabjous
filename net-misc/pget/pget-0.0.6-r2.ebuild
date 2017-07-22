# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

EGO_VENDOR=(
	"github.com/antonholmquist/jason 962e09b"
	"github.com/asaskevich/govalidator aa5cce4"
	"github.com/Code-Hex/updater c3f2786"
	"github.com/jessevdk/go-flags 75a96bc"
	"github.com/mattn/go-runewidth 97311d9"
	"github.com/mcuadros/go-version 257f7b9"
	"github.com/pkg/errors c605e28"
	"github.com/ricochet2200/go-disk-usage f0d1b74"
	"gopkg.in/cheggaaa/pb.v1 f6ccf21 github.com/cheggaaa/pb" #v1.0.15
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/sync f52d181 github.com/golang/sync" )
EGO_PN="github.com/Code-Hex/${PN}"

inherit golang-vcs-snapshot

DESCRIPTION="A parallel file download client in Go"
HOMEPAGE="https://github.com/Code-Hex/pget"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/pget
	dodoc src/${EGO_PN}/README.md
}
