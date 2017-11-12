# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 golang-vcs-snapshot systemd user

COMMIT_HASH="51ea240"
EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="zsh-completion"

RDEPEND="zsh-completion? ( app-shells/zsh )"
RESTRICT="mirror strip test"

DOCS=( {CHANGELOG,README}.md )

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup consul
	enewuser consul -1 -1 /var/lib/consul consul
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/version.GitCommit=${COMMIT_HASH} \
		-X ${EGO_PN}/version.GitDescribe=v${PV}"

	go build -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_install() {
	dobin consul
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/consul.d
	doins "${FILESDIR}"/*.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	newbashcomp contrib/bash-completion/_consul consul

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins contrib/zsh-completion/_consul
	fi

	diropts -o consul -g consul -m 0750
	dodir /var/log/consul
}
