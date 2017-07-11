# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/hanwen/go-fuse 5690be47d614355a22931c129e1075c25a62e9ac"
	"github.com/jacobsa/crypto 293ce0c192fb4f59cd879b46544922b9ed09a13a"
	"github.com/rfjakob/eme da627cc50b6fb2eb623eaffe91fb29d7eddfd06a"
	"golang.org/x/crypto 3627ff35f31987174dbee61d9d1dcc1c643e7174 github.com/golang/crypto"
	"golang.org/x/sync f52d1811a62927559de87708c8913c1650ce4f26 github.com/golang/sync"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/rfjakob/${PN}"
FUSE_COMMIT="5690be4"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
PKG_LDFLAGS="-X main.GitVersion=${PV} -X main.GitVersionFuse=${FUSE_COMMIT} -X main.BuildTime=$(date +%s)"

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +ssl"

DEPEND=">=dev-lang/go-1.8"
RDEPEND="sys-fs/fuse
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

src_compile() {
	local usessl=
	use ssl || usessl="-tags without_openssl"

	export GOPATH="${S}:$(get_golibdir_gopath)"
	go install -v -ldflags "${PKG_LDFLAGS}" ${usessl} ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	doman "${FILESDIR}"/${PN}.1
}
