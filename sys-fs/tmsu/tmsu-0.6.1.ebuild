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

EGO_PN="github.com/oniony/TMSU"
DESCRIPTION="Files tagger and virtual tag-based filesystem"
HOMEPAGE="https://github.com/oniony/TMSU"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

RESTRICT="mirror strip"

src_prepare() {
	# Move everything to src/${EGO_PN},
	# as we will use a vendored setup.
	mv src/${EGO_PN}/src/${EGO_PN}/* \
		src/${EGO_PN} || die

	default
}

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN} || die
}

src_test() {
	GOPATH="${S}" go test ${EGO_PN}/... || die
}

src_install() {
	newbin bin/TMSU tmsu

	pushd src/${EGO_PN} > /dev/null || die
	dosbin misc/bin/mount.tmsu
	dobin misc/bin/tmsu-*

	doman misc/man/tmsu.1

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/zsh/_tmsu
	fi
	popd > /dev/null || die
}
