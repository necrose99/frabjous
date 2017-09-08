# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot

MY_PV="Pre-GA"
COMMIT="46c1a0e"
EGO_PN="github.com/pingcap/tidb"
DESCRIPTION="A distributed NewSQL database compatible with MySQL protocol"
HOMEPAGE="https://github.com/pingcap/tidb"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

src_prepare() {
	ln -s _vendor/src src/${EGO_PN}/vendor || die

	sed -i \
		-e 's:LDFLAGS:GO_LDFLAGS:' \
		-e 's:$(shell git rev-parse HEAD)::g' \
			src/${EGO_PN}/Makefile || die

	default
}

src_compile() {
	local GOLDFLAGS="-s -w \
		-X '${EGO_PN}/util/printer.TiDBBuildTS=$(date -u '+%Y-%m-%d %I:%M:%S')' \
		-X ${EGO_PN}/util/printer.TiDBGitHash=${COMMIT}"

	emake -C src/${EGO_PN} parser

	GOPATH="${S}" go install -v -ldflags \
		"${GOLDFLAGS}" ${EGO_PN}/tidb-server || die
}

src_install() {
	dobin bin/tidb-server
}

pkg_postinst() {
	einfo "See https://pingcap.com/docs for configuration guide."
}
