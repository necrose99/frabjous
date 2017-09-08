# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with vendor/vendor.json
EGO_VENDOR=(
	"github.com/BurntSushi/toml a368813"
	"github.com/PuerkitoBio/purell b938d81"
	"github.com/PuerkitoBio/urlesc bbf7a2a"
	"github.com/bep/gitmap de8030e"
	"github.com/chaseadamsio/goorgeous 677defd"
	"github.com/cpuguy83/go-md2man 23709d0"
	"github.com/dchest/cssmin fb8d9b4"
	"github.com/eknkc/amber b8bd8b0"
	"github.com/fsnotify/fsnotify 4da3e2c"
	"github.com/gorilla/websocket ea4d1f6"
	"github.com/hashicorp/go-immutable-radix 8aac270"
	"github.com/hashicorp/golang-lru 0a025b7"
	"github.com/hashicorp/hcl 392dba7"
	"github.com/jdkato/prose c24611c"
	"github.com/kardianos/osext ae77be6"
	"github.com/kyokomi/emoji ddd4753"
	"github.com/magiconair/properties be5ece7"
	"github.com/markbates/inflect 6cacb66"
	"github.com/miekg/mmark fd2f6c1"
	"github.com/mitchellh/mapstructure d0303fe"
	"github.com/nicksnyder/go-i18n 3e70a1a"
	"github.com/pelletier/go-toml 69d355d"
	"github.com/russross/blackfriday 4048872"
	"github.com/shurcooL/sanitized_anchor_name 541ff5e"
	"github.com/spf13/afero 9be6508"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/cobra 34594c7"
	"github.com/spf13/fsync 12a01e6"
	"github.com/spf13/jwalterweatherman 0efa520"
	"github.com/spf13/nitro 24d7ef3"
	"github.com/spf13/pflag e57e3ee"
	"github.com/spf13/viper 25b30aa"
	"github.com/yosssi/ace ea038f4"
	"golang.org/x/image 426cfd8 github.com/golang/image"
	"golang.org/x/net f5079bd github.com/golang/net"
	"golang.org/x/sys 35ef448 github.com/golang/sys"
	"golang.org/x/text 836efe4 github.com/golang/text"
	"gopkg.in/yaml.v2 25c4ec8 github.com/go-yaml/yaml"
)
# Deps that are not needed:
# github.com/davecgh/go-spew/spew
# github.com/fortytw2/leaktest
# github.com/inconshreveable/mousetrap
# github.com/pelletier/go-buffruneio
# github.com/pmezard/go-difflib
# github.com/stretchr/testify

inherit golang-vcs-snapshot

EGO_PN="github.com/gohugoio/hugo"
DESCRIPTION="A Fast and Flexible Static Site Generator built with love in GoLang"
HOMEPAGE="https://gohugo.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pygments"

RDEPEND="pygments? ( >=dev-python/pygments-2.1.3 )"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/hugolib.BuildDate=$(date +%FT%T%z)"

	GOPATH="${S}" go install -v \
		-ldflags "${GOLDFLAGS}" ${EGO_PN} || die
}

src_install() {
	dobin bin/hugo

	bin/hugo gen man --dir="${T}"/man || die
	doman "${T}"/man/*
}
