# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with vendor/vendor.json
EGO_VENDOR=(
	"github.com/BurntSushi/toml a368813"
	"github.com/PuerkitoBio/purell b938d81"
	"github.com/PuerkitoBio/urlesc bbf7a2a"
	"github.com/bep/gitmap de8030e"
	"github.com/bep/inflect b896c45"
	"github.com/chaseadamsio/goorgeous 677defd"
	"github.com/cpuguy83/go-md2man 23709d0"
	"github.com/dchest/cssmin fb8d9b4"
	"github.com/eknkc/amber 5fa7895"
	"github.com/fsnotify/fsnotify 4da3e2c"
	"github.com/gorilla/websocket ea4d1f6"
	"github.com/hashicorp/go-immutable-radix 30664b8"
	"github.com/hashicorp/golang-lru 0a025b7"
	"github.com/hashicorp/hcl 392dba7"
	"github.com/kardianos/osext ae77be6"
	"github.com/kyokomi/emoji ddd4753"
	"github.com/magiconair/properties 51463bf"
	"github.com/miekg/mmark f809cc9"
	"github.com/mitchellh/mapstructure d0303fe"
	"github.com/nicksnyder/go-i18n 3e70a1a"
	"github.com/pelletier/go-toml 69d355d"
	"github.com/russross/blackfriday 067529f"
	"github.com/shurcooL/sanitized_anchor_name 541ff5e"
	"github.com/spf13/afero 9be6508"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/cobra 8c6fa02"
	"github.com/spf13/fsync 12a01e6"
	"github.com/spf13/jwalterweatherman 0efa520"
	"github.com/spf13/nitro 24d7ef3"
	"github.com/spf13/pflag e57e3ee"
	"github.com/spf13/viper c1de958"
	"github.com/yosssi/ace ea038f4"
	"golang.org/x/image 426cfd8 github.com/golang/image"
	"golang.org/x/net 054b33e github.com/golang/net"
	"golang.org/x/sys 6faef54 github.com/golang/sys"
	"golang.org/x/text cfdf022 github.com/golang/text"
	"gopkg.in/yaml.v2 cd8b52f github.com/go-yaml/yaml"
)
# Deps that are not needed:
# github.com/stretchr/testify
# github.com/davecgh/go-spew/spew
# github.com/fortytw2/leaktest
# github.com/inconshreveable/mousetrap
# github.com/kr/fs
# github.com/opennota/urlesc
# github.com/pkg/errors
# github.com/pkg/sftp
# github.com/pmezard/go-difflib
# golang.org/x/crypto

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
