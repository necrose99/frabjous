# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with cmd/micro/vendor
EGO_VENDOR=(
	"github.com/blang/semver 4a1e882"
	"github.com/dustin/go-humanize 259d2a1"
	"github.com/flynn/json5 7620272"
	"github.com/gdamore/encoding b23993c"
	"github.com/go-errors/errors 8fa88b0"
	"github.com/lucasb-eyer/go-colorful c900de9"
	"github.com/mattn/go-isatty fc9e8d8"
	"github.com/mattn/go-runewidth 97311d9"
	"github.com/mitchellh/go-homedir b8bc1bf"
	"github.com/sergi/go-diff feef008"
	"github.com/yuin/gopher-lua b402f31"
	"github.com/zyedidia/clipboard adacf41"
	"github.com/zyedidia/glob dd4023a"
	"github.com/zyedidia/pty 3036466"
	"github.com/zyedidia/tcell 208b6e8"
	"github.com/zyedidia/terminal 1760577"
	"golang.org/x/net 1a68b13 github.com/golang/net"
	"golang.org/x/text 210eee5 github.com/golang/text"
	"gopkg.in/yaml.v2 cd8b52f github.com/go-yaml/yaml"
	"layeh.com/gopher-luar 1628157 github.com/layeh/gopher-luar"
)
# Deps that are not needed:
# github.com/zyedidia/poller

inherit golang-vcs-snapshot

GIT_COMMIT="af520cf"
EGO_PN="github.com/zyedidia/micro"
DESCRIPTION="A modern and intuitive terminal-based text editor"
HOMEPAGE="https://micro-editor.github.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
RESTRICT="mirror strip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.Version=${PV} \
		-X main.CommitHash=${GIT_COMMIT} \
		-X main.CompileDate=$(date -u '+%Y-%m-%d' )"

	go build -v -ldflags "${GOLDFLAGS}" \
		./cmd/micro || die
}

src_test() {
	go test ./cmd/micro || die
}

src_install() {
	dobin micro
	dodoc runtime/help/*.md

	insinto /usr/share/micro
	doins -r runtime/{colorschemes,plugins,syntax,README.md}
}
