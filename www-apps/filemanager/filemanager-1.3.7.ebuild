# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/asdine/storm 2552124" #v1.1.0
	"github.com/boltdb/bolt 2f1ce7a" #v1.3.1
	"github.com/BurntSushi/toml a368813"
	"github.com/chaseadamsio/goorgeous e0b2cd6" #v2.0.0
	"github.com/daaku/go.zipexe a5fe243"
	"github.com/dgrijalva/jwt-go dbeaa93" #v3.1.0
	"github.com/dsnet/compress c4dbed6"
	"github.com/fsnotify/fsnotify 4da3e2c"
	"github.com/GeertJohan/go.rice c02ca9a"
	"github.com/gohugoio/hugo 142ebba" #v0.30.2
	"github.com/golang/snappy 553a641"
	"github.com/gorilla/websocket 71fa72d"
	"github.com/hacdias/fileutils 60f5c7b"
	"github.com/hacdias/varutils 200a811"
	"github.com/hashicorp/hcl 23c074d"
	"github.com/kardianos/osext ae77be6"
	"github.com/magiconair/properties 8d7837e"
	"github.com/mholt/archiver 26cf5bb"
	"github.com/mholt/caddy c4dfbb9" #v0.10.10
	"github.com/mitchellh/mapstructure 06020f8"
	"github.com/nwaples/rardecode f22b7ef"
	"github.com/pelletier/go-toml 16398ba" #v1.0.1
	"github.com/pierrec/lz4 08c2793"
	"github.com/pierrec/xxHash a0006b1"
	"github.com/robfig/cron 736158d"
	"github.com/russross/blackfriday 6d1ef89"
	"github.com/shurcooL/sanitized_anchor_name 86672fc"
	"github.com/spf13/afero 5660eee"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/jwalterweatherman 12bd96e"
	"github.com/spf13/pflag 97afa5e"
	"github.com/spf13/viper 8ef37cb"
	"github.com/ulikunitz/xz 0c6b41e"
	"golang.org/x/crypto 2509b14 github.com/golang/crypto"
	"golang.org/x/sys 661970f github.com/golang/sys"
	"golang.org/x/text 6eab0e8 github.com/golang/text"
	"gopkg.in/natefinch/lumberjack.v2 aee4629 github.com/natefinch/lumberjack"
	"gopkg.in/yaml.v2 eb3733d github.com/go-yaml/yaml"
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
