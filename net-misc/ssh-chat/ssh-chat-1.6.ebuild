# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/alexcesaro/log 61e6862"
	"github.com/dustin/go-humanize 2fcb520"
	"github.com/howeyc/gopass 26c6e11"
	"github.com/jessevdk/go-flags f2785f5"
	"github.com/shazow/rateio e8e0088"
	"golang.org/x/crypto 558b687 github.com/golang/crypto"
	"golang.org/x/sys e312636 github.com/golang/sys"
)
EGO_PN="github.com/shazow/ssh-chat"
EGO_LDFLAGS="-s -w -X main.Version=${PV}"

inherit golang-vcs-snapshot

DESCRIPTION="A chat over SSH server written in Go"
HOMEPAGE="https://github.com/shazow/ssh-chat"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "${EGO_LDFLAGS}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md

	#TODO: Add an init script!
}
