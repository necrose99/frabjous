# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FUSE_COMMIT="204b45d"
EGO_VENDOR=(
	"github.com/hanwen/go-fuse ${FUSE_COMMIT}"
	"github.com/jacobsa/crypto 293ce0c"
	"github.com/rfjakob/eme da627cc"
	"golang.org/x/crypto eb71ad9 github.com/golang/crypto"
	"golang.org/x/sync f52d181 github.com/golang/sync"
	"golang.org/x/sys 07c1829 github.com/golang/sys"
)

inherit golang-vcs-snapshot

EGO_PN="github.com/rfjakob/${PN}"
DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +ssl"

RDEPEND="sys-fs/fuse:0
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

RESTRICT="mirror strip"

src_compile() {
	local GOLDFLAGS usessl

	GOLDFLAGS="-s -w \
		-X main.GitVersion=${PV} \
		-X main.GitVersionFuse=${FUSE_COMMIT} \
		-X main.BuildTime=$(date +%s)"

	use ssl || usessl="-tags without_openssl"

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${usessl} ${EGO_PN} || die
}

src_install() {
	dobin bin/gocryptfs
	doman "${FILESDIR}"/gocryptfs.1
}
