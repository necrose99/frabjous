# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
RESTRICT="mirror strip"

inherit golang-vcs-snapshot

EGO_PN="github.com/variadico/${PN}"
DESCRIPTION="Trigger notifications when a process completes"
HOMEPAGE="https://github.com/variadico/noti"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		x11-libs/libnotify
		app-accessibility/espeak
	)"

src_compile() {
	GOPATH="${S}" go install -v -ldflags "-s -w" ${EGO_PN}/cmd/${PN} || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/docs/*.md
}
