# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Note: Keep EGO_VENDOR in sync with glide.lock
EGO_VENDOR=(
	"github.com/BurntSushi/toml bbd5bb6"
	"github.com/minio/blake2b-simd 3f5f724"
	"github.com/mitchellh/go-homedir 756f7b1"
	"github.com/yawning/chacha20 c91e78d"
	"golang.org/x/crypto d172538 github.com/golang/crypto"
)

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/jedisct1/${PN}"
DESCRIPTION="Copy/paste anything over the network"
HOMEPAGE="https://github.com/jedisct1/piknik"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="mirror strip"

DOCS=( ChangeLog README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_prepare() {
	if use test; then
		sed -i \
			-e "s:/tmp:${T}:g" \
			-e "/go build/d" \
			test.sh || die
	fi

	default
}

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" || die
}

src_test() {
	./test.sh || die
}

src_install() {
	dobin piknik
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc
	newins "${FILESDIR}"/piknik.conf piknik.toml
}

pkg_preinst() {
	enewgroup piknik
	enewuser piknik -1 -1 -1 piknik
}
