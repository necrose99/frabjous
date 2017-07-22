# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

EGO_VENDOR=(
	"github.com/blang/semver 4a1e882"
	"github.com/dustin/go-humanize 259d2a1"
	"github.com/gdamore/encoding b23993c"
	"github.com/go-errors/errors 8fa88b0"

	"gopkg.in/yaml.v2 1be3d31 github.com/go-yaml/yaml" #v2
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text 836efe4 github.com/golang/text"
	"layeh.com/gopher-luar 2fb8b2c github.com/layeh/gopher-luar" #v1.0.0

	"github.com/lucasb-eyer/go-colorful d1be5f1"
	"github.com/mattn/go-isatty fc9e8d8"
	"github.com/mattn/go-runewidth 97311d9"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/sergi/go-diff feef008"
	"github.com/yuin/gopher-lua 2243d71"

	"github.com/zyedidia/clipboard adacf41"
	"github.com/zyedidia/glob dd4023a"
	"github.com/zyedidia/json5 2518f8b"
	"github.com/zyedidia/tcell 7095cc1" )
EGO_PN="github.com/zyedidia/${PN}"
EGO_LDFLAGS="-s -w -X main.Version=${PV} -X main.CommitHash=be81241 -X 'main.CompileDate=$(date -u '+%Y-%m-%d' )'"

inherit golang-vcs-snapshot

DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v -ldflags \
		"${EGO_LDFLAGS}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/runtime/help/*.md
}
