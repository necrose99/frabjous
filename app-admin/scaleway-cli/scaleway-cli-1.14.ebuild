# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot

EGO_PN="github.com/scaleway/${PN}"
DESCRIPTION="Interact with Scaleway API from the command line"
HOMEPAGE="https://www.scaleway.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"

RESTRICT="mirror strip"

src_compile() {
	GOPATH="${S}" go build -v -ldflags "-s -w" ${EGO_PN}/cmd/scw || die
}

src_install() {
	dobin scw

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md

	dobashcomp contrib/completion/bash/scw

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/completion/zsh/_scw
	fi
	popd > /dev/null || die
}
