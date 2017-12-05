# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/asdine/storm dbd3772" #v2.0.0
	"github.com/BurntSushi/toml a368813"
	"github.com/chaseadamsio/goorgeous dcf1ef8" #v1.1.0
	"github.com/coreos/bbolt b436469"
	"github.com/daaku/go.zipexe a5fe243"
	"github.com/dgrijalva/jwt-go dbeaa93" #v3.1.0
	"github.com/dsnet/compress c4dbed6"
	"github.com/fsnotify/fsnotify 4da3e2c"
	"github.com/GeertJohan/go.rice c02ca9a"
	"github.com/gohugoio/hugo c1c04d7" #v0.31.1
	"github.com/golang/snappy 553a641"
	"github.com/gorilla/websocket b89020e"
	"github.com/hacdias/fileutils 76b1c6a"
	"github.com/hacdias/varutils 82d3b57"
	"github.com/hashicorp/hcl 23c074d"
	"github.com/kardianos/osext ae77be6"
	"github.com/magiconair/properties 49d762b" #v1.7.4
	"github.com/mholt/archiver 26cf5bb"
	"github.com/mholt/caddy c4dfbb9" #v0.10.10
	"github.com/mitchellh/mapstructure 06020f8"
	"github.com/nwaples/rardecode e06696f"
	"github.com/pelletier/go-toml 4e9e0ee"
	"github.com/pierrec/lz4 08c2793"
	"github.com/pierrec/xxHash a0006b1"
	"github.com/robfig/cron 2315d57"
	"github.com/russross/blackfriday 6d1ef89"
	"github.com/shurcooL/sanitized_anchor_name 86672fc"
	"github.com/spf13/afero 8d919cb"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/jwalterweatherman 12bd96e"
	"github.com/spf13/pflag 4c012f6"
	"github.com/spf13/viper 4dddf7c"
	"github.com/ulikunitz/xz 0c6b41e"
	"golang.org/x/crypto 94eea52 github.com/golang/crypto"
	"golang.org/x/sys 8b4580a github.com/golang/sys"
	"golang.org/x/text 5796168 github.com/golang/text"
	"gopkg.in/natefinch/lumberjack.v2 a96e638 github.com/natefinch/lumberjack"
	"gopkg.in/yaml.v2 287cf08 github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/hacdias/${PN}"
DESCRIPTION="A stylish web file manager"
HOMEPAGE="https://henriquedias.com/filemanager/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon"

RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	if use daemon; then
		enewgroup filemanager
		enewuser filemanager -1 -1 -1 filemanager
	fi
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X filemanager.Version=${PV}"

	go build -v -ldflags \
		"${GOLDFLAGS}" ./cmd/${PN} || die
}

src_install() {
	dobin filemanager

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		insinto /etc/filemanager
		newins "${FILESDIR}"/filemanager.conf \
			filemanager.yaml.example

		diropts -o filemanager -g filemanager -m 0750
		dodir /var/{lib,log,www}/filemanager
	fi
}

src_test() {
	go test -v ./... || die
}

pkg_postinst() {
	if use daemon; then
		if [ ! -e "${EROOT%/}"/etc/filemanager/filemanager.yaml ]; then
			elog "No filemanager.yaml found, copying the example over"
			cp "${EROOT%/}"/etc/filemanager/filemanager.yaml{.example,} || die
		else
			elog "filemanager.yaml found, please check example file for possible changes"
		fi
	fi
}
