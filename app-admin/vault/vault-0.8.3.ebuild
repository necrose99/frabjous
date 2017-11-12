# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fcaps golang-vcs-snapshot systemd user

COMMIT_HASH="6b29fb2"
EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip test"

DOCS=( {CHANGELOG,README}.md )

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/vault
)

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup vault
	enewuser vault -1 -1 -1 vault
}

src_compile() {
	export GOPATH="${G}"
	local GOLDFLAGS="-s -w \
		-X ${EGO_PN}/version.GitCommit=${COMMIT_HASH} \
		-X ${EGO_PN}/version.Version=${PV} \
		-X ${EGO_PN}/version.VersionPrerelease="

	go install -v -ldflags \
		"${GOLDFLAGS}" || die
}

src_install() {
	dobin "${G}"/bin/vault
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/vault.d
	doins "${FILESDIR}"/*.example

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	diropts -o vault -g vault -m 0750
	dodir /var/log/vault
}
