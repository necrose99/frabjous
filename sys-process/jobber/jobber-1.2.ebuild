# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

EGO_PN="github.com/dshearer/${PN}"
EGO_LDFLAGS="-s -w -X ${EGO_PN}/common.jobberVersion=${PV}"

inherit golang-vcs-snapshot user systemd

DESCRIPTION="A replacement for the classic Unix utility cron"
HOMEPAGE="https://dshearer.github.io/jobber/"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# Fix hardcoded path for the socket daemon
	sed -i "s:/var.*:/var/run/jobber_daemon.sock\":" \
		src/${EGO_PN}/common/consts.go || die

	# Fix hardcoded username
	sed -i "s:jobber_client:jobber:" \
		src/${EGO_PN}/jobberd/ipc_server.go || die

	eapply_user
}

src_compile() {
	GOPATH="${S}" go install -v -ldflags "${EGO_LDFLAGS}" \
		${EGO_PN}/{jobber,jobberd} || die
}

src_install() {
	dobin bin/${PN}
	dosbin bin/${PN}d

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
    enewgroup ${PN}
    enewuser ${PN} -1 -1 -1 ${PN}
}

pkg_postinst() {
	chown ${PN}:root "${EROOT%/}"/usr/bin/${PN} || die
	chmod 4755 "${EROOT%/}"/usr/bin/${PN} || die
}
