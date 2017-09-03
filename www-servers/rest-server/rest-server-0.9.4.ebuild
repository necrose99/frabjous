# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot systemd user

EGO_PN="github.com/restic/${PN}"
DESCRIPTION="A high performance HTTP server that implements restic's REST backend API"
HOMEPAGE="https://github.com/restic/rest-server"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-backup/restic-0.7.1"

RESTRICT="mirror strip"

src_prepare() {
	# Fix systemd unit file
	sed -i \
		-e "s:www-data:rest-server:" \
		-e "s:/usr/local:/usr:" \
		src/${EGO_PN}/etc/${PN}.service || die

	default
}

src_compile() {
	pushd src/${EGO_PN} > /dev/null || die
	GOPATH="${S}" go run build.go || die
	popd > /dev/null || die
}

src_install() {
	pushd src/${EGO_PN} > /dev/null || die
	dobin rest-server

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit etc/${PN}.service

	dodoc README.md
	popd > /dev/null || die
}

pkg_preinst() {
	enewgroup rest-server
	enewuser rest-server -1 -1 -1 rest-server
}
