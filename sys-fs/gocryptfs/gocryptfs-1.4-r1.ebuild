# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FUSE_COMMIT="a8bec8c"
EGO_VENDOR=(
	"github.com/hanwen/go-fuse ${FUSE_COMMIT}"
	"github.com/jacobsa/crypto 293ce0c"
	"github.com/rfjakob/eme da627cc"
	"golang.org/x/crypto dd85ac7 github.com/golang/crypto"
	"golang.org/x/sync f52d181 github.com/golang/sync"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/rfjakob/${PN}"
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
