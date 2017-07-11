# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/fatih/color 62e9147c64a1ed519147b62a56a14e83e2be02c1"
	"github.com/heppu/rawterm f84711c380fdfbaa529baff2605283945313a03c"
	"github.com/k0kubun/go-ansi c49b5436b29d52b735097d449e59d9794833bafe"
	"github.com/mitchellh/go-ps 4fdf99ab29366514c69ccccddab5dc58b8d84062"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/heppu/${PN}"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="An interactive process killer in Go (golang)"
HOMEPAGE="https://github.com/heppu/gkill"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-lang/go-1.8"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
}
