# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/asdine/storm 2552124" #v1.1.0
	"github.com/boltdb/bolt 2f1ce7a" #v1.3.1
	"github.com/BurntSushi/toml a368813"
	"github.com/chaseadamsio/goorgeous 098da33"
	"github.com/daaku/go.zipexe a5fe243"
	"github.com/dgrijalva/jwt-go a539ee1"
	"github.com/dsnet/compress c4dbed6"
	"github.com/fsnotify/fsnotify 4da3e2c"
	"github.com/GeertJohan/go.rice c02ca9a"
	"github.com/gohugoio/hugo 524c671" #v0.29
	"github.com/golang/snappy 553a641"
	"github.com/gorilla/websocket 4201258"
	"github.com/hacdias/fileutils 60f5c7b"
	"github.com/hacdias/varutils 200a811"
	"github.com/hashicorp/hcl 68e816d"
	"github.com/kardianos/osext ae77be6"
	"github.com/magiconair/properties 8d7837e"
	"github.com/mholt/archiver 3c2e5cf"
	"github.com/mholt/caddy f9cba03"
	"github.com/mitchellh/mapstructure d0303fe"
	"github.com/nwaples/rardecode f22b7ef"
	"github.com/pelletier/go-toml 16398ba"
	"github.com/pierrec/lz4 08c2793"
	"github.com/pierrec/xxHash a0006b1"
	"github.com/robfig/cron 736158d"
	"github.com/russross/blackfriday 4048872"
	"github.com/shurcooL/sanitized_anchor_name 86672fc"
	"github.com/spf13/afero ee1bd8e"
	"github.com/spf13/cast acbeb36"
	"github.com/spf13/jwalterweatherman 12bd96e"
	"github.com/spf13/pflag 7aff26d"
	"github.com/spf13/viper d9cca5e"
	"github.com/ulikunitz/xz 0c6b41e"
	"golang.org/x/crypto 34d0413 github.com/golang/crypto"
	"golang.org/x/sys 314a259 github.com/golang/sys"
	"golang.org/x/text 1cbadb4 github.com/golang/text"
	"gopkg.in/natefinch/lumberjack.v2 a96e638 github.com/natefinch/lumberjack"
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

src_setup() {
	if use daemon; then
		enewgroup filemanager
		enewuser filemanager -1 -1 -1 filemanager
	fi
}

src_compile() {
	GOLDFLAGS="-s -w -X filemanager.Version=${PV}"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/filemanager

	if use daemon; then
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		systemd_dounit "${FILESDIR}"/${PN}.service

		insinto /etc/filemanager
		newins "${FILESDIR}"/filemanager.conf filemanager.yaml.example

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
