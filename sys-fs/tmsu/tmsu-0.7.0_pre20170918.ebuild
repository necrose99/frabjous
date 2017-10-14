# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/hanwen/go-fuse bd6c960"
	"github.com/mattn/go-sqlite3 5160b48"
	"golang.org/x/net 0a93976 github.com/golang/net"
	"golang.org/x/sys 314a259 github.com/golang/sys"
)

inherit golang-vcs-snapshot

MY_PV="13095662e024e3d8bb99a6cac8da6cbf4819d25c"
EGO_PN="github.com/oniony/TMSU"
DESCRIPTION="Files tagger and virtual tag-based filesystem"
HOMEPAGE="https://github.com/oniony/TMSU"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror strip"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_prepare() {
	# Move everything to src/${EGO_PN},
	# as we will use a vendored setup.
	mv src/${EGO_PN}/* ./ || die

	default
}

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" \
		-o "${S}"/tmsu || die
}

src_test() {
	go test -v ./... || die
}

src_install() {
	dosbin misc/bin/mount.tmsu
	dobin misc/bin/tmsu-*
	dobin tmsu

	doman misc/man/tmsu.1

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/zsh/_tmsu
	fi
}
