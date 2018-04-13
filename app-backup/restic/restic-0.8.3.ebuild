# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot

EGO_PN="github.com/${PN}/${PN}"
DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion doc zsh-completion"

RDEPEND="sys-fs/fuse:0
	zsh-completion? ( app-shells/zsh )"
DEPEND="doc? ( dev-python/sphinx )"
RESTRICT="strip"

DOCS=( README.rst )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X main.version=${PV}"

	go build -v -tags release \
		-ldflags "${GOLDFLAGS}" \
		-asmflags "-trimpath=${S}" \
		-gcflags "-trimpath=${S}" \
		./cmd/restic || die

	if use doc; then
		HTML_DOCS=( doc/_build/html/. )
		emake -C doc html
	fi
}

src_test() {
	go test -timeout 30m -v -work -x \
		./cmd/... ./internal/... || die
}

src_install() {
	dobin restic
	einstalldocs

	doman doc/man/*.1

	use bash-completion && \
		newbashcomp doc/bash-completion.sh restic

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins doc/zsh-completion.zsh _restic
	fi
}
