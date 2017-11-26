# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion doc zsh-completion"

RDEPEND="sys-fs/fuse:0
	zsh-completion? ( app-shells/zsh )"
DEPEND=">=dev-lang/go-1.8.0
	doc? ( dev-python/sphinx )"
RESTRICT="strip"

DOCS=( README.rst )

src_compile() {
	GOPATH="${S}" emake restic

	if use doc; then
		HTML_DOCS=( doc/_build/html/. )
		emake -C doc html
	fi
}

src_test() {
	GOPATH="${S}:${S}/vendor" emake test
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
