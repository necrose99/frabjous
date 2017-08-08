# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/moul/${PN}"

inherit bash-completion-r1 golang-vcs

DESCRIPTION="A terminal client for GoTTY"
HOMEPAGE="https://github.com/moul/gotty-client"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"

RESTRICT="strip"

src_compile() {
	GOPATH="${S}" go install -v \
		-ldflags "-s -w" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/${PN}

	pushd src/${EGO_PN} > /dev/null || die
	dodoc README.md
	newbashcomp contrib/completion/bash_autocomplete ${PN}

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/completion/zsh_autocomplete _${PN}
	fi
	popd > /dev/null || die
}