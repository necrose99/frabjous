# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with Gopkg.lock
EGO_VENDOR=(
	"github.com/BurntSushi/toml a368813"
	"github.com/PuerkitoBio/purell 0bcb03f"
	"github.com/PuerkitoBio/urlesc de5bf2a"
	"github.com/alecthomas/chroma 9c81d25"
	"github.com/bep/gitmap de8030e"
	"github.com/chaseadamsio/goorgeous 7daffad"
	"github.com/cpuguy83/go-md2man 1d903dc"
	"github.com/danwakefield/fnmatch cbb64ac"
	"github.com/dchest/cssmin fb8d9b4"
	"github.com/dlclark/regexp2 487489b"
	"github.com/eknkc/amber cdade1c"
	"github.com/fsnotify/fsnotify 629574c"
	"github.com/gorilla/websocket ea4d1f6"
	"github.com/hashicorp/go-immutable-radix 8aac270"
	"github.com/hashicorp/golang-lru 0a025b7"
	"github.com/hashicorp/hcl 23c074d"
	"github.com/jdkato/prose 20d3663"
	"github.com/kardianos/osext ae77be6"
	"github.com/kyokomi/emoji 7e06b23"
	"github.com/magefile/mage 2f97430"
	"github.com/magiconair/properties be5ece7"
	"github.com/markbates/inflect ea17041"
	"github.com/miekg/mmark fd2f6c1"
	"github.com/mitchellh/mapstructure 06020f8"
	"github.com/nicksnyder/go-i18n 0dc1626"
	"github.com/pelletier/go-toml 16398ba"
	"github.com/russross/blackfriday 4048872"
	"github.com/shurcooL/sanitized_anchor_name 86672fc"
	"github.com/spf13/afero 8d919cb"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/cobra 7b2c5ac"
	"github.com/spf13/fsync 12a01e6"
	"github.com/spf13/jwalterweatherman 12bd96e"
	"github.com/spf13/nitro 24d7ef3"
	"github.com/spf13/pflag e57e3ee"
	"github.com/spf13/viper 25b30aa"
	"github.com/yosssi/ace ea038f4"
	"golang.org/x/image f7e31b4 github.com/golang/image"
	"golang.org/x/net cd69bc3 github.com/golang/net"
	"golang.org/x/sys 8dbc5d0 github.com/golang/sys"
	"golang.org/x/text c01e476 github.com/golang/text"
	"gopkg.in/yaml.v2 eb3733d github.com/go-yaml/yaml"
)
# Deps that are not needed:
# github.com/davecgh/go-spew 346938d
# github.com/fortytw2/leaktest 7dad533
# github.com/inconshreveable/mousetrap 76626ae
# github.com/pmezard/go-difflib 792786c
# github.com/stretchr/testify 69483b4

inherit golang-vcs-snapshot

GIT_COMMIT="c1c04d7"
EGO_PN="github.com/gohugoio/hugo"
DESCRIPTION="A static HTML and CSS website generator written in Go"
HOMEPAGE="https://gohugo.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pygments"

RDEPEND="pygments? ( >=dev-python/pygments-2.1.3 )"
RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/hugolib.CommitHash=${GIT_COMMIT} \
		-X ${EGO_PN}/hugolib.BuildDate=$(date +%FT%T%z)"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die

	./hugo gen man --dir="${T}"/man || die
}

src_install() {
	dobin hugo
	doman "${T}"/man/*
}
