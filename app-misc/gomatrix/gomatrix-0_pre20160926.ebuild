# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/davecgh/go-spew adab964"
	"github.com/gdamore/tcell 01ac1e4"
	"github.com/jessevdk/go-flags 6cf8f02"
	"github.com/gdamore/encoding b23993c"
	"github.com/lucasb-eyer/go-colorful d1be5f1"
	"github.com/mattn/go-runewidth 97311d9"
	"golang.org/x/text 3bd178b github.com/golang/text"
)
EGO_PN="github.com/GeertJohan/gomatrix"

inherit golang-vcs-snapshot

GIT_COMMIT="fec9e8c9052e9a330a8dc92e7c873f95415b94ae"
DESCRIPTION="Connects to The Matrix and displays it's data streams in your terminal"
HOMEPAGE="https://github.com/GeertJohan/gomatrix"
SRC_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md
}
