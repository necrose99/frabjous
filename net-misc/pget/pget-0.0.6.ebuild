# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/antonholmquist/jason 962e09b85496e2e158eec1567fb4c826ce3d55d1"
	"github.com/asaskevich/govalidator aa5cce4a76edb1a5acecab1870c17abbffb5419e"
	"github.com/Code-Hex/updater c3f2786725200723369a8f97b8b24bb19fe3baf4"
	"github.com/jessevdk/go-flags 5695738f733662da3e9afc2283bba6f3c879002d"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
	"github.com/mcuadros/go-version 257f7b9a7d87427c8d7f89469a5958d57f8abd7c"
	"github.com/pkg/errors c605e284fe17294bda444b34710735b29d1a9d90"
	"github.com/ricochet2200/go-disk-usage f0d1b743428fc09792f93233d9412f89f88fa2ab"
	"golang.org/x/net 054b33e6527139ad5b1ec2f6232c3b175bd9a30c github.com/golang/net"
	"golang.org/x/sync f52d1811a62927559de87708c8913c1650ce4f26 github.com/golang/sync"
	"gopkg.in/cheggaaa/pb.v1 f6ccf2184de4dd34495277e38dc19b6e7fbe0ea2 github.com/cheggaaa/pb"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/Code-Hex/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="A parallel file download client in Go"
HOMEPAGE="https://github.com/Code-Hex/pget"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/go-1.8"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md
}
