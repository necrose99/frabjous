# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/blang/semver 4a1e882c79dcf4ec00d2e29fac74b9c8938d5052"
	"github.com/dustin/go-humanize 259d2a102b871d17f30e3cd9881a642961a1e486"
	"github.com/gdamore/encoding b23993cbb6353f0e6aa98d0ee318a34728f628b9"
	"github.com/go-errors/errors 8fa88b06e5974e97fbf9899a7f86a344bfd1f105"

	"gopkg.in/yaml.v2 cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b github.com/go-yaml/yaml"
	"golang.org/x/net 054b33e6527139ad5b1ec2f6232c3b175bd9a30c github.com/golang/net"
	"golang.org/x/text cfdf022e86b4ecfb646e1efbd7db175dd623a8fa github.com/golang/text"
	"layeh.com/gopher-luar 1972b4907aa8c3e1acedf1c0fc093541c69e1742 github.com/layeh/gopher-luar"

	"github.com/lucasb-eyer/go-colorful d1be5f1fbc7f63e693f460df83d52772eae2ca54"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
	"github.com/mitchellh/go-homedir b8bc1bf767474819792c23f32d8286a45736f1c6"
	"github.com/sergi/go-diff feef008d51ad2b3778f85d387ccf91735543008d"
	"github.com/yuin/gopher-lua 2243d714d6c94951d8ccca8c851836ff47d401c9"

	"github.com/zyedidia/clipboard adacf416cec40266b051e7bc096c52951f2725e9"
	"github.com/zyedidia/glob dd4023a66dc351ae26e592d21cd133b5b143f3d8"
	"github.com/zyedidia/json5 2518f8beebde6814f2d30d566260480d2ded2f76"
	"github.com/zyedidia/tcell 7095cc1c7f4173ae48314d80878e9985a0658889"
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

DEPEND=">=dev-lang/go-1.8"

src_compile() {
	export GOPATH="${S}:$(get_golibdir_gopath)"

	go install -v -ldflags "${PKG_LDFLAGS}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}
	dodoc src/${EGO_PN}/runtime/help/*.md
}
