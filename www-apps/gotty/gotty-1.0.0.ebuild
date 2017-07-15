# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

EGO_PN="github.com/yudai/gotty"
DESCRIPTION="A simple command line tool that turns your CLI tools into web applications"
HOMEPAGE="https://github.com/yudai/gotty"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	GOPATH="${S}" go install -v ${EGO_PN} || die
}

src_install() {
	dobin bin/hey
	dodoc src/${EGO_PN}/README.md
}
