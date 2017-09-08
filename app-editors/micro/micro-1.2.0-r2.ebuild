# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/blang/semver 2ee8785" #v3.5.1
	"github.com/dustin/go-humanize 259d2a1"
	"github.com/gdamore/encoding b23993c"
	"github.com/go-errors/errors 8fa88b0"

	"gopkg.in/yaml.v2 25c4ec8 github.com/go-yaml/yaml" #v2
	"golang.org/x/net f5079bd github.com/golang/net"
	"golang.org/x/text 836efe4 github.com/golang/text"
	"layeh.com/gopher-luar 6a6a71f github.com/layeh/gopher-luar" #v1.0.1

	"github.com/lucasb-eyer/go-colorful d1be5f1"
	"github.com/mattn/go-isatty fc9e8d8"
	"github.com/mattn/go-runewidth 97311d9"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/sergi/go-diff feef008"
	"github.com/yuin/gopher-lua 2243d71"

	"github.com/zyedidia/clipboard adacf41"
	"github.com/zyedidia/glob dd4023a"
	"github.com/zyedidia/json5 2518f8b"
	"github.com/zyedidia/tcell 7095cc1"
)

inherit golang-vcs-snapshot

GIT_COMMIT="be81241"
EGO_PN="github.com/zyedidia/micro"
DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w \
		-X main.Version=${PV} \
		-X main.CommitHash=${GIT_COMMIT} \
		-X 'main.CompileDate=$(date -u '+%Y-%m-%d' )'"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN}/cmd/micro || die
}

src_install() {
	dobin bin/micro
	dodoc src/${EGO_PN}/runtime/help/*.md
}
