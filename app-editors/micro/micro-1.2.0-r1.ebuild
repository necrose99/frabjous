# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/blang/semver 4a1e882"
	"github.com/dustin/go-humanize 259d2a1"
	"github.com/gdamore/encoding b23993c"
	"github.com/go-errors/errors 8fa88b0"

	"gopkg.in/yaml.v2 1be3d31 github.com/go-yaml/yaml" #v2
	"golang.org/x/net f01ecb6 github.com/golang/net"
	"golang.org/x/text cfdf022 github.com/golang/text"
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
	"github.com/zyedidia/tcell 7095cc1"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/zyedidia/${PN}"
EGIT_COMMIT="be81241"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
PKG_LDFLAGS="-X main.Version=${PV} -X main.CommitHash=${EGIT_COMMIT} -X 'main.CompileDate=$(date -u '+%Y-%m-%d' )'"

DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "${PKG_LDFLAGS}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/runtime/help/*.md
}
