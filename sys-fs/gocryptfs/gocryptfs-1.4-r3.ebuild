# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

FUSE_COMMIT="5690be4" #v20170619
EGO_VENDOR=(
	"github.com/hanwen/go-fuse ${FUSE_COMMIT}"
	"github.com/jacobsa/crypto 293ce0c"
	"github.com/rfjakob/eme da627cc"
	"golang.org/x/crypto 6914964 github.com/golang/crypto"
	"golang.org/x/sync f52d181 github.com/golang/sync"
	"golang.org/x/sys c4489fa github.com/golang/sys"
)

EGO_PN="github.com/rfjakob/${PN}"
PKG_LDFLAGS="-s -w -X main.GitVersion=${PV} -X main.GitVersionFuse=${FUSE_COMMIT} -X main.BuildTime=$(date +%s)"

inherit golang-vcs-snapshot

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
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

	GOPATH="${S}" go install -v \
		-ldflags "${PKG_LDFLAGS}" ${usessl} ${EGO_PN} || die
}

src_install() {
	dobin bin/${PN}
	doman "${FILESDIR}"/${PN}.1
}
