# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot

GIT_COMMIT="0f1c821"
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

DOCS=( README.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/pkg/scwversion.GITCOMMIT=${GIT_COMMIT}"

	go build -v -ldflags \
		"${GOLDFLAGS}" ./cmd/scw || die
}

src_test() {
	go test -v ./cmd/scw/ || die
	go test -v ./pkg/{sshcommand,pricing,cli}/ || die
}

src_install() {
	dobin scw
	einstalldocs

	newbashcomp contrib/completion/bash/scw.bash scw

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/completion/zsh/_scw
	fi
}
