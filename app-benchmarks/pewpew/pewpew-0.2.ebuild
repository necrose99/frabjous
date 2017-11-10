# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
EGO_VENDOR=(
	"github.com/fatih/color 9131ab3"
	"github.com/fsnotify/fsnotify a904159"
	"github.com/hashicorp/hcl 372e8dd"
	"github.com/lucasjones/reggen bed4659"
	"github.com/magiconair/properties b3b15ef"
	"github.com/mitchellh/mapstructure db1efb5"
	"github.com/pelletier/go-buffruneio df1e16f"
	"github.com/pelletier/go-toml a1f048b"
	"github.com/spf13/afero 72b3142"
	"github.com/spf13/cast d1139ba"
	"github.com/spf13/cobra ec2fe78"
	"github.com/spf13/jwalterweatherman fa7ca7e"
	"github.com/spf13/pflag 9ff6c69"
	"github.com/spf13/viper 5ed0fc3"
	"golang.org/x/net 7bf7a75 github.com/golang/net"
	"golang.org/x/sys e24f485 github.com/golang/sys"
	"golang.org/x/text 506f9d5 github.com/golang/text"
	"gopkg.in/yaml.v2 4c78c97 github.com/go-yaml/yaml"
)
# Deps that are not needed:
# github.com/inconshreveable/mousetrap
# github.com/mattn/go-colorable
# github.com/mattn/go-isatty

inherit golang-vcs-snapshot

EGO_PN="github.com/bengadbois/${PN}"
DESCRIPTION="Flexible HTTP command line stress tester for websites and web services"
HOMEPAGE="https://github.com/bengadbois/pewpew"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" || die
}

src_install() {
	dobin pewpew
	einstalldocs

	if use examples; then
		docinto examples
		dodoc -r examples/config.{json,toml}
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
