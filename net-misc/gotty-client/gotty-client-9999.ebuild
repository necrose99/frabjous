# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs

EGO_PN="github.com/moul/${PN}"
DESCRIPTION="A terminal client for GoTTY"
HOMEPAGE="https://github.com/moul/gotty-client"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"
RESTRICT="strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"

	go build -v -ldflags "-s -w" \
		./cmd/gotty-client || die
}

src_install() {
	dobin gotty-client
	einstalldocs

	newbashcomp contrib/completion/bash_autocomplete gotty-client

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/completion/zsh_autocomplete _gotty-client
	fi
}
