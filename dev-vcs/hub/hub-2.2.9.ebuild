# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot

EGO_PN="github.com/github/hub"
DESCRIPTION="A command-line wrapper for git that makes you better at GitHub"
HOMEPAGE="https://hub.github.com/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

RDEPEND=">=dev-vcs/git-1.7.3
	zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror strip"

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	go build -v -ldflags "-s -w" || die
}

src_install() {
	dobin hub
	einstalldocs

	doman man/hub.1

	newbashcomp etc/hub.bash_completion.sh hub

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins etc/hub.zsh_completion _hub
	fi
}
